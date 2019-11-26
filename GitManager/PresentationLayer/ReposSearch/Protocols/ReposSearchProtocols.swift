//
//  ReposSearchProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 14.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol ReposSearchViewProtocol: ReposListViewProtocol {
    var presenterStarred:  ReposSearchPresenterProtocol?     { get set }
}

protocol ReposSearchPresenterProtocol: ReposListPresenterProtocol {
    var interactorSearch: ReposSearchInteractorProtocol?    { get set }
    var viewSearch:       ReposSearchViewProtocol?          { get set }
    var routerSearch:     ReposSearchRouterProtocol?        { get set }
}

protocol ReposSearchInteractorProtocol: ReposListInteractorProtocol {
    var presenterSearch:  ReposSearchPresenterProtocol?     { get set }
}

protocol ReposSearchRouterProtocol: ReposListRouterProtocol {

}
