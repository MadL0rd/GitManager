//
//  FiltersViewProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 21.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

protocol FiltrationManagerProtocol: class {

    func addParameter(name : String, type : FilterParameterType, groupTitle : String)
    func deleteParameter(name : String, type : FilterParameterType, groupTitle : String)
    func deleteGroup(groupTitle : String, type : FilterParameterType)
    func deleteAllParameters()
    func getTagParameterState(name : String, groupTitle : String) -> Bool?
    func getStringParameterState(name : String, groupTitle : String) -> String?
    func setTagParameterState(name : String, groupTitle : String, value : Bool)
    func setStringParameterState(name : String, groupTitle : String, value : String)
    func getAllTagParametersState() -> Dictionary<String, Dictionary<String, Bool>>
    func getAllStringParametersState() -> Dictionary<String, Dictionary<String, String>>
    func dropAllParameters()
    func setAllTagsInGroup(groupTitle: String)
    func dropAllTagsInGroup(groupTitle: String)
}

enum FilterParameterType {
    case tag
    case string
}
