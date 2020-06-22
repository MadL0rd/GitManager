//
//  AuthenticationView.swift
//  GitManager
//
//  Created by Антон Текутов on 09.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class AuthenticationView: UIView {
    
    let logo = LogoView()
    let title = UILabel()
    let signInButton = ButtonWithStack()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Public methods
    
    func showSignInButton() {
        
        UIView.transition(with: signInButton,
                          duration: 1, animations: {
                            self.signInButton.transform = CGAffineTransform.init(translationX: 0, y: 0)
                            self.signInButton.alpha = 1
        })
    }
    
    // MARK: - Private setup methods
    
    private func setupView() {
        
        backgroundColor = Colors.mainColor
        
        setupLogoView()
        setupSignIn()
        
        makeConstraints()
    }
    
    private func setupLogoView() {
        addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.layer.shadowOpacity = 0
        logo.animateLayer(\.shadowOpacity, to: 0.6, duration: 0.5)
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 50)
        title.textColor = Colors.lightText
        title.text = "GIT\nMANAGER"
        title.numberOfLines = 2
        title.textAlignment = .center
    }
    
    private func setupSignIn() {
        
        addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.backgroundColor = Colors.mainBackground
        signInButton.layer.cornerRadius = 30
        signInButton.alpha = 0
        signInButton.transform = CGAffineTransform.init(translationX: 0, y: 80)
        
        let label = UILabel()
        Designer.mainTitleLabel(label, textColor: Colors.mainColor)
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.text = "Sign in with"
        label.textAlignment = .center
        signInButton.stack.addArrangedSubview(label)
        
        let image = UIImageView(image: #imageLiteral(resourceName: "gitHub").withRenderingMode(.alwaysTemplate))
        image.tintColor = Colors.mainColor
        signInButton.stack.addArrangedSubview(image)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            logo.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -170),
            logo.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            signInButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 170),
            signInButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}
