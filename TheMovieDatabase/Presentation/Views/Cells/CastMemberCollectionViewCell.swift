//
//  CastMemberCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import UIKit

class CastMemberCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CastMemberCell"

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let characterLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)

        imageView.anchor(top: contentView.topAnchor, 
                         width: 100,
                         height: 100)
        imageView.centerX(inView: contentView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true

        nameLabel.anchor(top: imageView.bottomAnchor, 
                         left: contentView.leftAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 8)

        characterLabel.anchor(top: nameLabel.bottomAnchor, 
                              left: contentView.leftAnchor,
                              right: contentView.rightAnchor,
                              paddingTop: 4)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with castMember: CastMember) {
        if let url = constructImageURL(path: castMember.profileURL ?? "", withQuality: .medium) {
            imageView.kf.setImage(with: url)
        }
        nameLabel.text = castMember.name
        characterLabel.text = castMember.character
    }
}
