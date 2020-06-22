//
//  LogoView.swift
//  GitManager
//
//  Created by Антон Текутов on 09.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class LogoView: UIView {
    
    let backgroundLogo = UIImageView()
    let logo = UIImageView()
    let eyesCoverView = UIView()
    var eyesCoverHeight: NSLayoutConstraint?
    
    var duration: TimeInterval = 0.25
    var blinkDelay: TimeInterval = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private setup methods
    
    private func setupView() {
        
        layer.shadowColor = Colors.shadowColor.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: 4)
        
        addSubview(backgroundLogo)
        backgroundLogo.translatesAutoresizingMaskIntoConstraints = false
        backgroundLogo.image = #imageLiteral(resourceName: "logoBackground").withRenderingMode(.alwaysTemplate)
        backgroundLogo.tintColor = Colors.mainColor
                
        addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = #imageLiteral(resourceName: "logoWithLlines").withRenderingMode(.alwaysTemplate)
        logo.tintColor = Colors.mainBackground
        
        addSubview(eyesCoverView)
        eyesCoverView.translatesAutoresizingMaskIntoConstraints = false
        eyesCoverView.backgroundColor = logo.tintColor
        eyesCoverView.layer.cornerRadius = 5
        
        blink()
        
        makeConstraints()
    }
    
    private func blink() {
        let blinkOnce = {
            UIView.animate(withDuration: self.duration, animations: { [ weak self ] in
                guard let self = self 
                    else { return }
                self.eyesCoverHeight?.constant = 12
                self.layoutIfNeeded()
            })
            UIView.animate(withDuration: self.duration, delay: self.duration, animations: { [ weak self ] in
                guard let self = self 
                    else { return }
                self.eyesCoverHeight?.constant = 0
                self.layoutIfNeeded()
            })
        }
        blinkOnce()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) {
            blinkOnce()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + blinkDelay) {
            self.blink()
        }
    }
    
    private func makeConstraints() {
        eyesCoverHeight = eyesCoverView.heightAnchor.constraint(equalToConstant: 0)
        backgroundLogo.setMargin(0)
        logo.setMargin(0)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 200),
            heightAnchor.constraint(equalToConstant: 200),
            
            eyesCoverView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -2),
            eyesCoverView.topAnchor.constraint(equalTo: centerYAnchor, constant: 8),
            eyesCoverView.widthAnchor.constraint(equalToConstant: 30),
            eyesCoverHeight!,
        ])
    }
}
