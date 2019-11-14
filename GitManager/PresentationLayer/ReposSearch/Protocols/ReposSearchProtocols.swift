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
    var interactorStarred: ReposSearchInteractorProtocol?    { get set }
    var viewStarred:       ReposSearchViewProtocol?          { get set }
    var routerStarred:     ReposSearchRouterProtocol?        { get set }
}

protocol ReposSearchInteractorProtocol: ReposListInteractorProtocol {
    var presenterStarred:  ReposSearchPresenterProtocol?     { get set }
}

protocol ReposSearchRouterProtocol: ReposListRouterProtocol {

}
