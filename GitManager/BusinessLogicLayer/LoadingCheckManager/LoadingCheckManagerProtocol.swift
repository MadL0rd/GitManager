//
//  LoadingCheckManagerProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 04.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol LoadingCheckManagerProtocol : class {
    func beginTask(taskName : String) -> Int //return taskId
    func endTask(taskId : Int)
    func subscribe(showLoading : @escaping()->Void, endLoading: @escaping()->Void)
}

extension LoadingCheckManagerProtocol{
    func beginTask() -> Int {
        return beginTask(taskName: "* noNameTask *")
    }
}
