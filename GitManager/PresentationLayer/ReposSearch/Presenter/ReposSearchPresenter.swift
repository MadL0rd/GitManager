//
//  ReposSearchPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 14.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ReposSearchPresenter: ReposListPresenter, ReposSearchPresenterProtocol {
    
    var interactorSearch: ReposSearchInteractorProtocol?
    var viewSearch: ReposSearchViewProtocol?
    var routerSearch: ReposSearchRouterProtocol?
    
    func refreshFiltersText(filters: [String]){
        viewSearch?.refreshFiltersText(filters: filters)
    }
}
