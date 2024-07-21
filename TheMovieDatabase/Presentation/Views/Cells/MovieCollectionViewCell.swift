//
//  MovieCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import UIKit
import Kingfisher
class MovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentified = "MovieCell"
    private let moviePosterImageView = UIImageView()
    private let movieTitleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let releaseDateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init coder not implemented")
    }

    private func setupViews() {
        addSubview(moviePosterImageView)
        moviePosterImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
        moviePosterImageView.layer.cornerRadius = 12
        moviePosterImageView.clipsToBounds = true
        moviePosterImageView.contentMode = .scaleAspectFill

        let labelsStackView = UIStackView()
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 4
        labelsStackView.distribution = .fillProportionally
        labelsStackView.addArrangedSubview(movieTitleLabel)
        labelsStackView.addArrangedSubview(subtitleLabel)
        labelsStackView.addArrangedSubview(releaseDateLabel)

        addSubview(labelsStackView)
        labelsStackView.centerX(inView: self)
        labelsStackView.anchor(top: moviePosterImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 4, paddingBottom: 8, paddingRight: 4)
    }

    func configure(withMovie movie: MoviePresentationModel) {
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w300/"+(movie.posterPath ?? ""))
        moviePosterImageView.kf.setImage(with: imageURL)
        movieTitleLabel.text = movie.title
        subtitleLabel.text = movie.voteAverage != nil ? String(format: "%.2f", movie.voteAverage!) : "NA"
        releaseDateLabel.text = movie.releaseDate
    }
}
