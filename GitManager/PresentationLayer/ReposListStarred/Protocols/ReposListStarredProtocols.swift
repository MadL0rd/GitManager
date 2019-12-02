//
//  ReposListStarredProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol ReposListStarredViewProtocol: ReposListViewProtocol {
    var presenterStarred:  ReposListStarredPresenterProtocol?     { get set }
}

protocol ReposListStarredPresenterProtocol: ReposListPresenterProtocol {
    var interactorStarred: ReposListStarredInteractorProtocol?    { get set }
    var viewStarred:       ReposListStarredViewProtocol?          { get set }
    var routerStarred:     ReposListStarredRouterProtocol?        { get set }
}

protocol ReposListStarredInteractorProtocol: ReposListInteractorProtocol {
    var presenterStarred:  ReposListStarredPresenterProtocol?     { get set }
}

protocol ReposListStarredRouterProtocol: ReposListRouterProtocol {

}

