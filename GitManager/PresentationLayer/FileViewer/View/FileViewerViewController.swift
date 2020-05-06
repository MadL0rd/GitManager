//
//  FileViewerViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class FileViewerViewController: UIViewController {

    var presenter: FileViewerPresenterProtocol!
    private var _view: FileViewerView {
        return view as! FileViewerView
    }

    override func loadView() {
        self.view = FileViewerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

// MARK: - FileViewerViewInput

extension FileViewerViewController: FileViewerViewProtocol {

}
