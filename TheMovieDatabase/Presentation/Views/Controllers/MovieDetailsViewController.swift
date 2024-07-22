//
//  MovieDetailsViewController.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import UIKit
import Combine

class MovieDetailsViewController: UIViewController {

    var movieID: Int!
    private var viewModel: MovieDetailsViewModel!
    private var cancellables = Set<AnyCancellable>()

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let ratingLabel = UILabel()
    private var genresCollectionView: UICollectionView!
    private var castCollectionView: UICollectionView!
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var genresDataSource: UICollectionViewDiffableDataSource<Int, Genre>!
    private var castDataSource: UICollectionViewDiffableDataSource<Int, CastMember>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewModel()
        configureViews()
        bindViewModel()
        Task {
            await viewModel.fetchMovieDetails(movieID: movieID)
            await viewModel.fetchMovieCast(movieID: movieID)
        }
    }

    private func configureViews() {
        configureScrollView()
        configurePosterImageView()
        configureTitleLabel()
        configureOverviewLabel()
        configureRatingLabel()
        configureGenresCollectionView()
        configureCastCollectionView()
    }
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        NSLayoutConstraint.activate([
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    private func configurePosterImageView() {
        contentView.addSubview(posterImageView)
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 300)
    }
    private func configureTitleLabel() {
         titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: posterImageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
     }

     private func configureOverviewLabel() {
         overviewLabel.numberOfLines = 0
         contentView.addSubview(overviewLabel)

         overviewLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
     }

     private func configureRatingLabel() {
         ratingLabel.font = UIFont.systemFont(ofSize: 18)
         contentView.addSubview(ratingLabel)
         ratingLabel.anchor(top: overviewLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16)
     }
    private func configureGenresCollectionView() {
        let layout = createHorizontalLayout()
        genresCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        genresCollectionView.register(GenresCollectionViewCell.self, forCellWithReuseIdentifier: GenresCollectionViewCell.reuseIdentifier)
        genresCollectionView.backgroundColor = .white
        contentView.addSubview(genresCollectionView)

        genresCollectionView.anchor(top: ratingLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 50)
        genresDataSource = UICollectionViewDiffableDataSource<Int, Genre>(collectionView: genresCollectionView) { (collectionView, indexPath, genre) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCollectionViewCell.reuseIdentifier, for: indexPath) as! GenresCollectionViewCell
            cell.configure(with: genre)
            return cell
        }
    }

    private func configureCastCollectionView() {
        let layout = createHorizontalLayout()
        castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        castCollectionView.register(CastMemberCollectionViewCell.self, forCellWithReuseIdentifier: CastMemberCollectionViewCell.reuseIdentifier)
        castCollectionView.backgroundColor = .white
        contentView.addSubview(castCollectionView)

        castCollectionView.anchor(top: genresCollectionView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: 150)
        castDataSource = UICollectionViewDiffableDataSource<Int, CastMember>(collectionView: castCollectionView) { (collectionView, indexPath, castMember) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastMemberCollectionViewCell.reuseIdentifier, for: indexPath) as! CastMemberCollectionViewCell
            cell.configure(with: castMember)
            return cell
        }
    }

    private func createHorizontalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(20)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.orthogonalScrollingBehavior = .continuous

            return section
        }
    }
    private func setupViewModel() {
        let movieRemoteDataSource = DefaultRemoteDataSource(moviesAPI: MoviesAPI())
        let movieRepository = DefaultMoviesRepo(remoteDataSource: movieRemoteDataSource) // Ensure MovieRepositoryImpl is defined
        let fetchMovieDetailsUseCase = DefaultFetchMovieDetailsUseCase(movieRepo: movieRepository)
        let fetchMovieCastUseCase = DefaultFetchMovieCastUseCase(movieRepo: movieRepository)

        viewModel = MovieDetailsViewModel(fetchMovieDetailsUseCase: fetchMovieDetailsUseCase, fetchMovieCastUseCase: fetchMovieCastUseCase)
    }
    private func bindViewModel() {
        viewModel.$movieDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] details in
                guard let details = details else { return }
                self?.updateUI(with: details)
            }
            .store(in: &cancellables)
        viewModel.$movieCast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cast in
                guard let cast = cast else { return }
                self?.updateCast(with: cast)
            }
            .store(in: &cancellables)
    }
    private func updateUI(with details: MovieDetails) {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/"+(details.posterURL ?? "")) {
            posterImageView.kf.setImage(with: url)
        }
        titleLabel.text = details.title
        overviewLabel.text = details.overView
        handleRatingText(rating: details.rating)
        updateGenresCollectionView(with: details.genres)
    }
    private func updateCast(with cast: [MovieCast]) {
        updateCastCollectionView(with: cast)
    }
    private func updateCastCollectionView(with cast: [MovieCast]) {
        // map to presentation model
        let castMembers = cast.map{CastMember(id: $0.id, name: $0.name, character: $0.character, profileURL: $0.profilePath)}
        var snapshot = NSDiffableDataSourceSnapshot<Int, CastMember>()
        snapshot.appendSections([0])
        snapshot.appendItems(castMembers, toSection: 0)
        castDataSource.apply(snapshot, animatingDifferences: true)
    }
    private func updateGenresCollectionView(with genres: [Genre]?) {
        guard let genres else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Genre>()
        snapshot.appendSections([0])
        snapshot.appendItems(genres, toSection: 0)
        genresDataSource.apply(snapshot, animatingDifferences: true)
    }
    private func handleRatingText(rating: Double?) {
        ratingLabel.text = "Rating: " + (rating != nil ? String(format: "%.2f", rating!) : "NA")
        if let rating {
            if (0..<6).contains(rating) {
                if rating == 0 {
                    ratingLabel.textColor = .black
                    ratingLabel.text = "NA"
                } else {
                    ratingLabel.textColor = .red
                }
            }
            else if (6..<7.5).contains(rating) {
                ratingLabel.textColor = .orange
            }
            else if (7.5...10).contains(rating) {
                ratingLabel.textColor = .systemGreen
            }
        }
            else {
                ratingLabel.textColor = .black
            }
    }
}
