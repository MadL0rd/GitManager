//
//  FileViewerView.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class FileViewerView: UIView {
    
    let spacing: CGFloat = 10
    
    let title = UILabel()

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
        
        addSubview(title)
        Designer.bigTitleLabel(title)
        title.numberOfLines = 0
        title.text = "Gamno"
        title.textAlignment = .center

        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: spacing),
            title.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor,constant: spacing),
            title.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor,constant: -spacing)
        ])
    }
}
