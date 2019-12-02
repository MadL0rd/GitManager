//
//  FiltersView.swift
//  GitManager
//
//  Created by Антон Текутов on 21.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class FiltrationManager: FiltrationManagerProtocol {
    
    private var tagGroups = Dictionary<String, Dictionary<String, Bool>>() //key - group name, value - included items <name - value>
    private var stringGroups = Dictionary<String, Dictionary<String, String>>() //key - group name, value - included items <name - value>
    
    func addParameter(name: String, type: FilterParameterType, groupTitle: String) {
        switch type {
        case FilterParameterType.tag:
            if tagGroups[groupTitle] == nil {
                tagGroups[groupTitle] = Dictionary<String, Bool>()
                tagGroups[groupTitle]?[name] = true
            }else{
                if tagGroups[groupTitle]?[name] == nil {
                    tagGroups[groupTitle]?[name] = true
                }else{
                    print("Parameter \(name) in group \(groupTitle) already exist!")
                }
            }
        case FilterParameterType.string:
            if stringGroups[groupTitle] == nil {
                stringGroups[groupTitle] = Dictionary<String, String>()
                stringGroups[groupTitle]?[name] = ""
            }else{
                if stringGroups[groupTitle]?[name] == nil {
                    stringGroups[groupTitle]?[name] = ""
                }else{
                    print("Parameter \(name) in group \(groupTitle) already exist!")
                }
            }
        }
    }
    
    func deleteParameter(name: String, type: FilterParameterType, groupTitle: String){
        switch type {
        case FilterParameterType.tag:
            if tagGroups[groupTitle]?[name] != nil {
                tagGroups[groupTitle]?[name] = nil
                if tagGroups[groupTitle]?.isEmpty ?? false {
                    tagGroups[groupTitle] = nil
                }
            }
        case FilterParameterType.string:
            if stringGroups[groupTitle]?[name] != nil {
                stringGroups[groupTitle]?[name] = nil
                if stringGroups[groupTitle]?.isEmpty ?? false {
                    stringGroups[groupTitle] = nil
                }
            }
        }
    }
    
    func deleteGroup(groupTitle: String, type: FilterParameterType) {
        switch type {
        case FilterParameterType.tag:
            tagGroups[groupTitle] = nil
        case FilterParameterType.string:
            stringGroups[groupTitle] = nil
        }
    }
    
    func deleteAllParameters() {
        tagGroups = Dictionary<String, Dictionary<String, Bool>>()
        stringGroups = Dictionary<String, Dictionary<String, String>>()
    }
    
    func getTagParameterState(name: String, groupTitle: String) -> Bool? {
        return tagGroups[groupTitle]?[name]
    }
    
    func getStringParameterState(name: String, groupTitle: String) -> String? {
        return stringGroups[groupTitle]?[name]
    }
    
    func setTagParameterState(name: String, groupTitle: String, value: Bool) {
        if tagGroups[groupTitle]?[name] != nil {
            tagGroups[groupTitle]?[name] = value
        }else{
            print("Parameter \(name) in group \(groupTitle) does not exist!")
        }
    }
    
    func setStringParameterState(name: String, groupTitle: String, value: String){
        if stringGroups[groupTitle]?[name] != nil {
            stringGroups[groupTitle]?[name] = value
        }else{
            print("Parameter \(name) in group \(groupTitle) does not exist!")
        }
    }
    
    func getAllTagParametersState() -> Dictionary<String, Dictionary<String, Bool>> {
        return tagGroups
    }
    
    func getAllStringParametersState() -> Dictionary<String, Dictionary<String, String>> {
        return stringGroups
    }
    
    func dropAllParameters() {
        for group in tagGroups{
            for param in group.value{
                tagGroups[group.key]?[param.key] = true
            }
        }
        for group in stringGroups{
            for param in group.value{
                stringGroups[group.key]?[param.key] = ""
            }
        }
    }
    
    func setAllTagsInGroup(groupTitle: String) {
        if let group = tagGroups[groupTitle]{
            for param in group{
                tagGroups[groupTitle]?[param.key] = true
            }
        }else{
            print("Group \(groupTitle) does not exist!")
        }
    }
    
    func dropAllTagsInGroup(groupTitle: String) {
        if let group = tagGroups[groupTitle]{
            for param in group{
                tagGroups[groupTitle]?[param.key] = false
            }
        }else{
            print("Group \(groupTitle) does not exist!")
        }
    }
}
