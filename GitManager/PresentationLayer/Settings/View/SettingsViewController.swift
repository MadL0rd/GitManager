//
//  SettingsViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 10.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var menu: [MenuModule] {
        get {
            return presenter.getMenu()
        }
    }

    var presenter: SettingsPresenterProtocol!
    private var _view: SettingsView {
        return view as! SettingsView
    }

    override func loadView() {
        self.view = SettingsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Settings", comment: "")
        
        _view.table.delegate = self
        _view.table.dataSource = self
        _view.table.register(MenuRowTableViewCell.self, forCellReuseIdentifier: MenuRowTableViewCell.identifier)
        
        presenter.viewDidLoad()
    }
}

// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewProtocol {

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuRowTableViewCell.identifier, for: indexPath) as? MenuRowTableViewCell ?? MenuRowTableViewCell()
        cell.title.text = menu[indexPath.section].actions[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menu[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menu[indexPath.section].actions[indexPath.row].action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
