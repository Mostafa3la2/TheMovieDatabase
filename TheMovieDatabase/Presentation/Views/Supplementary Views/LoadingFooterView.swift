//
//  LoadingFooterView.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import UIKit

class LoadingFooterView: UICollectionReusableView {
    static let reuseIdentifier = "LoadingFooterView"

       private let activityIndicator: UIActivityIndicatorView = {
           let activityIndicator = UIActivityIndicatorView(style: .medium)
           activityIndicator.translatesAutoresizingMaskIntoConstraints = false
           activityIndicator.hidesWhenStopped = true
           return activityIndicator
       }()

       override init(frame: CGRect) {
           super.init(frame: frame)
           addSubview(activityIndicator)

           activityIndicator.center(inView: self)
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       func startAnimating() {
           activityIndicator.startAnimating()
       }

       func stopAnimating() {
           activityIndicator.stopAnimating()
       }
}
