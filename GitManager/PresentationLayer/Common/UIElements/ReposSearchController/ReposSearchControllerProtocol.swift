//
//  ReposSearchControllerProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 12.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol ReposSearchControllerProtocol {
    init(owner: ReposSearchControllerOwnerProtocol)
    func setScopeBottonsText(buttonsText: [String])
}

protocol ReposSearchControllerOwnerProtocol {
    func searchTextChanged(text : String)
    func scopeButtonPressed(text : String)
    func filterButtonPressed()
}

