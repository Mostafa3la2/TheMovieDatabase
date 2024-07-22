//
//  ErrorPopupView.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import UIKit

class ErrorPopupView: UIView {

    private let messageLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        self.layer.cornerRadius = 10

        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)

        self.addSubview(messageLabel)
        self.addSubview(closeButton)

        messageLabel.anchor(top: self.topAnchor,
                            left: self.leftAnchor,
                            right: self.rightAnchor,
                            paddingTop: 20,
                            paddingLeft: 20,
                            paddingRight: 20)
        closeButton.anchor(top: messageLabel.bottomAnchor,
                            paddingTop: 20)
        closeButton.centerX(inView: self)
    }

    @objc func dismiss() {
        self.removeFromSuperview()
    }

    func showMessage(_ message: String, in view: UIView) {
        messageLabel.text = message
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        keyWindow.addSubview(self)

        self.anchor(top: keyWindow.topAnchor, left: keyWindow.leftAnchor, right: keyWindow.rightAnchor, paddingTop: 100, paddingLeft: 60, paddingRight: 60, height: 100)

        UIView.animate(withDuration: 0.5) {
            self.frame.origin.y = view.safeAreaInsets.top + 20
            self.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.dismiss()
        }
    }
}
