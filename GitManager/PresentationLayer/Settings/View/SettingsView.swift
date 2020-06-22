//
//  SettingsView.swift
//  GitManager
//
//  Created by Антон Текутов on 10.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    let logo = LogoView()
    let logoBackground = UIView()
    let table = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }

    // MARK: - Private methods
    
    private func setupView() {
        
        backgroundColor = Colors.mainBackground
        
        setupLogo()
        setupTable()

        makeConstraints()
    }
    
    private func setupLogo() {
        
        addSubview(logoBackground)
        logoBackground.translatesAutoresizingMaskIntoConstraints = false
        logoBackground.backgroundColor = Colors.mainColorWithAlpha
        logoBackground.layer.cornerRadius = 110
        
        addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTable() {
        addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.bounces = false
        table.alwaysBounceVertical = false
        table.tableFooterView = UIView()
    }

    private func makeConstraints() {
		NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            logo.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            logoBackground.widthAnchor.constraint(equalTo: logo.widthAnchor, constant: 20),
            logoBackground.heightAnchor.constraint(equalTo: logo.heightAnchor, constant: 20),
            logoBackground.centerXAnchor.constraint(equalTo: logo.centerXAnchor),
            logoBackground.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: 10),
            
            table.topAnchor.constraint(equalTo: logoBackground.bottomAnchor, constant: 10),
            table.centerXAnchor.constraint(equalTo: centerXAnchor),
            table.widthAnchor.constraint(equalTo: widthAnchor),
            table.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
