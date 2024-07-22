//
//  GenresCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import UIKit

class GenresCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "GenreCell"

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)

        label.centerX(inView: contentView)
        label.centerY(inView: contentView)
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        contentView.layer.borderColor = UIColor.black.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with genre: Genre) {
        label.text = genre.name
    }
}
