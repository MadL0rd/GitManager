//
//  ReposSearchControllerProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 12.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol ReposSearchControllerProtocol {
    init(owner: ReposSearchControllerOwnerProtocol)
    func setFiltersText(filters: [String])
}

protocol ReposSearchControllerOwnerProtocol {
    func applyFilters(text : String?, language : String)
}

