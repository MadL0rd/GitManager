//
//  NoContentViewProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 22.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

protocol NoContentViewProtocol: UIView {
    
    var visibility: Bool            { get }
    
    func toggleDisplayingState()
    func show()
    func hide()
    func setReloadAction(_ action: @escaping(()-> Void))
}
