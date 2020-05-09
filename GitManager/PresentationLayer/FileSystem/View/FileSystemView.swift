//
//  FileSystemView.swift
//  GitManager
//
//  Created by Антон Текутов on 05.04.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class FileSystemView: UIView {
    
    let spacing: CGFloat = 10
    
    let branch = UIButton()
    let loading = UIActivityIndicatorView()
    let path = UILabel()
    let filesCollection = FileSystemCollectionView()

    private let branchBackground = UIView()
    private let branchImage = UIImageView()

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
        
        setupFilesCollectionView()
        setupBranchOptions()

        makeConstraints()
    }
    
    private func setupBranchOptions() {
        addSubview(branchBackground)
        branchBackground.translatesAutoresizingMaskIntoConstraints = false
        branchBackground.backgroundColor = Colors.mainColorWithAlpha
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = branchBackground.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        branchBackground.addSubview(blurEffectView)
        
        addSubview(branchImage)
        branchImage.translatesAutoresizingMaskIntoConstraints = false
        let templateImage = #imageLiteral(resourceName: "branch").withRenderingMode(.alwaysTemplate)
        branchImage.image = templateImage
        branchImage.tintColor = Colors.mainBackground
        
        addSubview(loading)
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.startAnimating()
        loading.color = Colors.mainBackground
        
        addSubview(branch)
        branch.translatesAutoresizingMaskIntoConstraints = false
        Designer.borderedClearButton(branch, color: Colors.mainBackground)
        
        addSubview(path)
        Designer.subTitleLabel(path)
        path.textColor = Colors.mainBackground
        path.lineBreakMode = .byTruncatingHead
        path.text = "/"
    }
    
    private func setupFilesCollectionView() {
        addSubview(filesCollection)
        filesCollection.translatesAutoresizingMaskIntoConstraints = false
        filesCollection.collection.contentInset = UIEdgeInsets(top: 90, left: spacing * 2, bottom: spacing, right: spacing * 2)
        filesCollection.alpha = 0
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            branchImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: spacing),
        	branchImage.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: spacing),
            branchImage.heightAnchor.constraint(equalToConstant: 30),
        	branchImage.widthAnchor.constraint(equalToConstant: 30),
            
            branch.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: spacing),
            branch.leftAnchor.constraint(equalTo: branchImage.rightAnchor, constant: spacing),
            branch.rightAnchor.constraint(equalTo: rightAnchor, constant: -spacing),
            branch.heightAnchor.constraint(equalToConstant: 30),
            
            loading.centerYAnchor.constraint(equalTo: branch.centerYAnchor),
        	loading.centerXAnchor.constraint(equalTo: branch.centerXAnchor),
            
            path.topAnchor.constraint(equalTo: branch.bottomAnchor, constant: spacing),
            path.leftAnchor.constraint(equalTo: leftAnchor, constant: spacing),
            path.rightAnchor.constraint(equalTo: rightAnchor, constant: -spacing),
            
            branchBackground.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            branchBackground.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            branchBackground.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            branchBackground.bottomAnchor.constraint(equalTo: path.bottomAnchor, constant: spacing),
            
            filesCollection.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            filesCollection.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            filesCollection.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            filesCollection.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
