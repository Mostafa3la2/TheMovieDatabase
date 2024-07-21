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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMoviesCollectionView()
        setupDataSource()
        setupViewModel()
        bindViewModel()
        Task {
            await moviesViewModel.fetchPopularMovies()
        }
        self.title = "Popular Movies"
        // Do any additional setup after loading the view.
    }
    
    private func setupMoviesCollectionView() {
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex, layoutEnv) -> NSCollectionLayoutSection? in
            return self.createLayout()
        }
        moviesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentified)
        moviesCollectionView.backgroundColor = .white
        view.addSubview(moviesCollectionView)
        moviesCollectionView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
    }
    private func createLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

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
        moviesViewModel = PopularMoviesListViewModel(fetchMoviesUseCase: moviesUsecase)
    }
    private func bindViewModel() {
        moviesViewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.applySnapshot(movies: movies)
            }
            .store(in: &cancellables)
    }
    
}
