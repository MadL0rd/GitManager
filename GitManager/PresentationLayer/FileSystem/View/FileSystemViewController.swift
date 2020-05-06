//
//  FileSystemViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 05.04.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class FileSystemViewController: UIViewController, FileSystemViewProtocol {
    
    let duration: TimeInterval = 0.25

    var presenter: FileSystemPresenterProtocol!
    private var _view: FileSystemView {
        return view as! FileSystemView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _view.filesCollection.alpha = 1
    }

    override func loadView() {
        self.view = FileSystemView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _view.branch.addTarget(self, action: #selector(selectBranch), for: .touchUpInside)
        _view.filesCollection.delegate = self

        presenter.viewDidLoad()
    }
    
    // MARK: - UI elements actions
    
    @objc private func selectBranch() {
        let choices = presenter.getBranches()
        showAlertWithPicker(title: NSLocalizedString("Branch", comment: ""), 
                            message: NSLocalizedString("Chose branch you want to open", comment: ""), 
                            pickerItems: choices, 
                            stringReturnHandler: { branch in 
                                self._view.loading.startAnimating()
                                self.presenter.selectBranch(branch)
        })
    }
    
    // MARK: - Public methods
    
    func showSelectedBranch(_ branch: String) {
        UIView.transition(with: _view.branch, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self._view.branch.setTitle(branch, for: .normal)
        })
        _view.loading.stopAnimating()
    }
    
    func showCatalog(_ catalog: [Directory], havePreviousDir: Bool = true) {
        _view.filesCollection.directories = catalog
        _view.filesCollection.havePreviousDir = havePreviousDir
        _view.filesCollection.reloadCollection()
    }
    
    func showPath(_ path: String) {
        _view.path.text = path
    }
}

extension FileSystemViewController: FileSystemCollectionViewDelegate {
    
    func cellDidTapped(_ index: Int) {
        UIView.animate(withDuration: duration, animations: {
            self._view.filesCollection.alpha = 0
        })
        presenter.cellDidTapped(index)
    }
}
