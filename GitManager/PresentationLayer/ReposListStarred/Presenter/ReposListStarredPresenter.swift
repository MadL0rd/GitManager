//
//  ReposListStarredPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ReposListStarredPresenter: ReposListPresenter, ReposListStarredPresenterProtocol {
    
    var interactorStarred: ReposListStarredInteractorProtocol?
    var viewStarred: ReposListStarredViewProtocol?
    var routerStarred: ReposListStarredRouterProtocol?
    
}
