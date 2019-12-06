//
//  LoadingCheckManager.swift
//  GitManager
//
//  Created by Антон Текутов on 04.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class LoadingCheckManager: LoadingCheckManagerProtocol {
    
    private var taskCount = 0
    private var tasks = Dictionary<Int, String>()
    private var subscribers = [(showLoading: () -> Void, endLoading: () -> Void)]()
    
    func beginTask(taskName: String) -> Int {
        if tasks.count == 0 {
            for subscriber in subscribers {
                subscriber.showLoading()
            }
        }
        taskCount += 1
        tasks[taskCount] = taskName
        print("Task \(taskName) begins")
        return taskCount
    }
    
    func endTask(taskId: Int) {
        if let taskName = tasks[taskId] {
            print("Task \(taskName) ends")
            tasks[taskId] = nil
            if tasks.count == 0 {
                for subscriber in subscribers {
                    subscriber.endLoading()
                }
            }
        } else {
            print("\t!!!WARNING!!!\nTask with id \(taskId) does not exist!")
        }
    }
    
    func subscribe(showLoading: @escaping () -> Void, endLoading: @escaping () -> Void) {
        subscribers.append((showLoading: showLoading, endLoading: endLoading))
        if tasks.count != 0 {
            showLoading()
        }
    }
}
