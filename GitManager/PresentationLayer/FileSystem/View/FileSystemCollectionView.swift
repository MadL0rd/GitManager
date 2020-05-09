//
//  FileSystemCollectionView.swift
//  GitManager
//
//  Created by Антон Текутов on 05.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

protocol FileSystemCollectionViewDelegate: class {
    
    func cellDidTapped(_ index: Int)
}

class FileSystemCollectionView: UIView {
    
    weak var delegate: FileSystemCollectionViewDelegate?
    
    var duration: TimeInterval = 0.2
    
    let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout = UICollectionViewFlowLayout.init()

    var havePreviousDir = false
    var directories = [Directory]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Public methods
    
    func reloadCollection() {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: { [ weak self ] _ in
            guard let self = self 
                else { return }
            self.collection.reloadData()
            UIView.animate(withDuration: self.duration, animations: {
                self.alpha = 1
            })
        })
        
    }
    
    // MARK: - Private methods
    
    private func setupView() {
                
        addSubview(collection)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collection.setCollectionViewLayout(layout, animated: true)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(DirectoryCollectionViewCell.self, forCellWithReuseIdentifier: DirectoryCollectionViewCell.identifier)
        collection.backgroundColor = .clear
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: topAnchor),
            collection.bottomAnchor.constraint(equalTo: bottomAnchor),
            collection.rightAnchor.constraint(equalTo: rightAnchor),
            collection.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension FileSystemCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DirectoryCollectionViewCell.identifier, for: indexPath) as? DirectoryCollectionViewCell ?? DirectoryCollectionViewCell()
        cell.setContent(directories[indexPath.row])
        if havePreviousDir && indexPath.row == 0 {
            cell.makeDesignPrevious()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FileSystemCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellDidTapped(indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FileSystemCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 100)
    }
}

