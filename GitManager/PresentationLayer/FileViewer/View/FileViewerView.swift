//
//  FileViewerView.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit
import MarkdownView

class FileViewerView: UIView {
    
    let mdView = MarkdownView()
	let loading: LoadingViewProtocol = LoadingView()
    let errorLabel = UILabel()
    
    let spacing: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }

    // MARK: - Private methods
    
    private func setupView() {
        
        backgroundColor = Colors.mainBackground
        
        addSubview(mdView)
        mdView.translatesAutoresizingMaskIntoConstraints = false
        mdView.isScrollEnabled = true
        mdView.setMargin(baseView: safeAreaLayoutGuide, 0)
        
        addSubview(loading)
        loading.setMargin(0)
        loading.show(animation: false)
        
        addSubview(errorLabel)
        Designer.bigTitleLabel(errorLabel)
        errorLabel.textColor = errorLabel.textColor.withAlphaComponent(0.5)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.text = NSLocalizedString("Sorry\nWe can`t represent this file", comment: "")
        errorLabel.isHidden = true
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        ])
    }
    
}
