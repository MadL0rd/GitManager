//
//  FileViewerProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

protocol FileViewerViewProtocol {
    
    var presenter: FileViewerPresenterProtocol! { get set }
}

protocol FileViewerPresenterProtocol {
    
    var view: FileViewerViewProtocol? { get set }
    var interactor: FileViewerInteractorProtocol! { get set }
    var router: FileViewerRouterProtocol! { get set }
    
    func viewDidLoad()
}

protocol FileViewerInteractorProtocol {
    
    var presenter: FileViewerPresenterProtocol! { get set }
}

protocol FileViewerRouterProtocol {
    
}
