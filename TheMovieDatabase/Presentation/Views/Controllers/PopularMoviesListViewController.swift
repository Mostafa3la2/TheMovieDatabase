//
//  PopularMoviesListViewController.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import UIKit
import Combine

class PopularMoviesListViewController: UIViewController {

    enum Section {
        case main
    }
    var moviesCollectionView: UICollectionView!
    var moviesDataSource: UICollectionViewDiffableDataSource<Section, MoviePresentationModel>!
    var moviesViewModel: PopularMoviesListViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var footerView: UICollectionReusableView!
    private let pageLoader = UIActivityIndicatorView(style: .large)
    private let refreshIndicator = UIRefreshControl()
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        setupMoviesCollectionView()
        setupDataSource()
        setupViewModel()
        setupPageLoader()
        bindViewModel()
        Task {
            await moviesViewModel.fetchPopularMovies()
        }
        self.title = "Popular Movies"
        // Do any additional setup after loading the view.
    }
    private func setupSearchBar() {
        searchBar.placeholder = "Search Movies"
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, 
                         left: self.view.leftAnchor,
                         right: self.view.rightAnchor)
    }
    private func setupPageLoader() {
        view.addSubview(pageLoader)
        pageLoader.center(inView: view)
        pageLoader.hidesWhenStopped = true
        pageLoader.startAnimating()
    }
    private func setupMoviesCollectionView() {
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            return self.createLayout()
        }
        moviesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentified)
        moviesCollectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.reuseIdentifier)
        moviesCollectionView.backgroundColor = .white
        view.addSubview(moviesCollectionView)
        moviesCollectionView.anchor(top: searchBar.bottomAnchor, 
                                    left: self.view.leftAnchor,
                                    bottom: self.view.bottomAnchor,
                                    right: self.view.rightAnchor)
        refreshIndicator.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        moviesCollectionView.refreshControl = refreshIndicator
        moviesCollectionView.delegate = self
    }
    private func createLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [footer]

        return section
    }
    private func setupDataSource() {
        moviesDataSource = UICollectionViewDiffableDataSource<Section, MoviePresentationModel>(collectionView: moviesCollectionView) {(collectionView, indexPath, movie) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentified, for: indexPath) as? MovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(withMovie: movie)
            return cell
        }
        moviesDataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionFooter else { return UICollectionReusableView() }
            self.footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.reuseIdentifier, for: indexPath) as! LoadingFooterView
            return self.footerView
        }
    }
    private func applySnapshot(movies: [MoviePresentationModel], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MoviePresentationModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies, toSection: .main)
        moviesDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    // will be separated later
    private func setupViewModel() {
        let moviesAPI = MoviesAPI()
        let moviesDataSource = DefaultRemoteDataSource(moviesAPI: moviesAPI)
        let moviesRepo = DefaultMoviesRepo(remoteDataSource: moviesDataSource)
        let moviesUsecase = DefaultFetchPopularMoviesUseCase(moviesRepo: moviesRepo)
        let searchMoviesUsecase = DefaultSearchMoviesUseCase(moviesRepo: moviesRepo)
        moviesViewModel = PopularMoviesListViewModel(fetchMoviesUseCase: moviesUsecase, searchMoviesUseCase: searchMoviesUsecase)
    }
    private func bindViewModel() {
        moviesViewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                if self?.refreshIndicator.isRefreshing == true {
                    self?.refreshIndicator.endRefreshing()
                }
                self?.pageLoader.stopAnimating()
                self?.applySnapshot(movies: movies)
            }
            .store(in: &cancellables)
        moviesViewModel?.$isFetching
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    (self?.footerView as? LoadingFooterView)?.startAnimating()
                } else {
                    (self?.footerView as? LoadingFooterView)?.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    @objc func pullToRefresh() {
        Task {
            await moviesViewModel?.fetchPopularMovies(resetPage: true)
        }
    }
}
extension PopularMoviesListViewController: UICollectionViewDelegate {
    // MARK: Pagination Logic
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height && moviesViewModel.isFetching == false {
            Task {
                await moviesViewModel?.fetchNextPage()
                print("called")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = moviesViewModel.movies[indexPath.row]
        let movieDetailsVC = MovieDetailsViewController()
        movieDetailsVC.movieID = movie.id
        self.navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
extension PopularMoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Task {
            if searchText.isEmpty {
                await moviesViewModel.fetchPopularMovies(resetPage: true)
            } else {
                await moviesViewModel.searchMovies(firstSearch: true, with: searchText)
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
