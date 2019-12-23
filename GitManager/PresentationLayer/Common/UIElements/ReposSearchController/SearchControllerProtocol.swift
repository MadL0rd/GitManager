//
//  ReposSearchControllerProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 12.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//
import UIKit

protocol SearchControllerProtocol {
    init(owner: SearchControllerOwnerProtocol, searchResultsController: UIViewController?)
    func setScopeBottonsText(buttonsText: [String])
}

protocol SearchControllerOwnerProtocol {
    func searchTextChanged(text : String)
    func scopeButtonPressed(text : String)
    func filterButtonPressed()
    func searchBarStartMoving()
}

