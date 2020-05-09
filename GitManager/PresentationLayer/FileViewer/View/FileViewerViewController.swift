//
//  FileViewerViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit
import WebKit

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

        _view.webView.navigationDelegate = self
        
        let image = #imageLiteral(resourceName: "sharing")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(shareRepository))
        navigationItem.rightBarButtonItem = button
        
        presenter.viewDidLoad()
    }
    
    @objc private func shareRepository(){
        let message = NSLocalizedString("You can get the file from this link:\n", comment: "")
        let textToShare = [ message + presenter.getFileLink() ]
        let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - FileViewerViewInput

extension FileViewerViewController: FileViewerViewProtocol {
    
    func showFileContent(_ htmlSource: String) {
        _view.webView.loadHTMLString(htmlSource, baseURL: nil)
        if htmlSource == "" {
            _view.errorLabel.isHidden = false
            _view.errorLabel.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                self._view.errorLabel.alpha = 1
            })
            
        }
    }
}

extension FileViewerViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if webViewFirstLoadingComplete {
            if let url = navigationAction.request.url{
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
            webViewFirstLoadingComplete.toggle()
        }
        _view.loading.hide()
    }
}
