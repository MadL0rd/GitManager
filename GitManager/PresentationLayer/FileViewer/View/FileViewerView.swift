//
//  FileViewerView.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit
import WebKit

class FileViewerView: UIView {
    
    var webView = WKWebView()
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
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.setMargin(0)
        webView.scrollView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        webView.scrollView.minimumZoomScale = 0.4
        webView.scrollView.maximumZoomScale = 10.0
        webView.scrollView.zoomScale = 2
        
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
