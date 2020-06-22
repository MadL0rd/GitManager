//
//  FileViewerViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit
import SafariServices
import MarkdownView

class FileViewerViewController: UIViewController {
    
    private var webViewFirstLoadingComplete = false

    var presenter: FileViewerPresenterProtocol!
    private var _view: FileViewerView {
        return view as! FileViewerView
    }

    override func loadView() {
        self.view = FileViewerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        _view.mdView.onRendered = mdRendered(_:)
        _view.mdView.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }
            
            if url.scheme == "file" {
                return true
            } else if url.scheme == "https" {
                let safari = SFSafariViewController(url: url)
                self?.present(safari, animated: true, completion: nil)
                return false
            } else {
                return false
            }
        }
        
        let image = #imageLiteral(resourceName: "sharing")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(shareRepository))
        navigationItem.rightBarButtonItem = button
        
        presenter.viewDidLoad()
    }
    
    @objc private func shareRepository(){
        let textToShare = [ URL(string: presenter.getFileLink()) ]
        let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func mdRendered(_ value: CGFloat){
        _view.loading.hide()
    }
}

// MARK: - FileViewerViewInput

extension FileViewerViewController: FileViewerViewProtocol {
    
    func showFileContent(_ content : String?, fileExtension: String) {
        if let content = content {
            _view.mdView.loadWithCodeSyntax(content: content, fileExtension: fileExtension)
        } else {
            _view.loading.hide()
            _view.errorLabel.isHidden = false
            _view.errorLabel.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                self._view.errorLabel.alpha = 1
            })
        }
    }
}
