//
//  ReposTableViewerProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//
import UIKit

protocol ReposTableViewerProtocol: UIView {
    init(owner: ReposTableViewerOwnerProtocol)
    func showReposList()
    func refreshCell(index: Int)
}

protocol ReposTableViewerOwnerProtocol: class {
    func getItemsCount() -> Int
    func getItemWithIndex(index: Int) -> Repository?
    func starRepository(index: Int)
    func showRepositoryPage(index: Int)
}
