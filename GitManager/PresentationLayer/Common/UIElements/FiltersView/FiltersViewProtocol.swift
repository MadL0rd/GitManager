//
//  FiltersViewProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 25.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

protocol FiltersViewProtocol : UIView {
    
    var filters : FiltrationManagerProtocol { get }
    
    func setApplyAction(action: @escaping () -> Void)
    func drawUI()
}
