//
//  ReposListView.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListViewController: UIViewController, ReposListViewProtocol{
    
    var reposViewer: ReposTableViewer?
    var presenter: ReposListPresenterProtocol?
    var searchController: (UISearchController & ReposSearchControllerProtocol)?
    let footer = SearchFooterButton()
    var footerHidenBottomConstraint : NSLayoutConstraint?
    var footerVisibleBottomConstraint : NSLayoutConstraint?
    var footerHiden = true
    let filtrationView: FiltersViewProtocol = FiltersView()
    let filtrationBackground = UIButton()
    var filtersHidenConstraint : NSLayoutConstraint?
    var filtersVisibleConstraint : NSLayoutConstraint?
    var filtersHiden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }
    
    internal func setupView(){
        setupNavigationTitle()
        setupTableView()
        setupSearchController()
        setupFooter()
        setupFilterationManagerView()
        
        setupInheritor()
    }
    
    internal func setupInheritor(){
        
    }
    
    internal func setupNavigationTitle(){
        navigationItem.title = NSLocalizedString("My repositories", comment: "Title on repositories screen")
    }
    
    internal func setupTableView() {
        guard let owner = presenter as? ReposTableViewerOwnerProtocol else { return }
        reposViewer = ReposTableViewer(owner: owner)
        guard let reposView = reposViewer else { return }
        view.addSubview(reposView)
        reposView.translatesAutoresizingMaskIntoConstraints = false
        reposView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        reposView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        reposView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        reposView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        reposView.backgroundColor = Colors.mainBackground
        setupAddictionalContentMode()
    }
    
    internal func setupFooter(){
        view.addSubview(footer)
        footer.translatesAutoresizingMaskIntoConstraints = false
        footerHidenBottomConstraint = footer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        footerVisibleBottomConstraint = footer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.view.frame.height/10)
        footerHidenBottomConstraint?.isActive = true
        footer.heightAnchor.constraint(equalToConstant: view.frame.height/20).isActive = true
        footer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width/16).isActive = true
        footer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -view.frame.width/16).isActive = true
        footer.addTarget(self, action: #selector(loadNextPage), for: .touchUpInside)
    }
    internal func setupFilterationManagerView(){
        view.addSubview(filtrationBackground)
        filtrationBackground.translatesAutoresizingMaskIntoConstraints = false
        filtrationBackground.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        filtrationBackground.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        filtrationBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filtrationBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        filtrationBackground.backgroundColor = Colors.disable
        filtrationBackground.alpha = 0
        filtrationBackground.addTarget(self, action: #selector(filterationManagerDisplaingChange), for: .touchUpInside)
        
        filtrationView.setApplyAction {
            self.presenter?.applyFilters(filtrationManager: self.filtrationView.filters)
        }
        view.addSubview(filtrationView)
        filtrationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filtrationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        filtrationView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        filtersVisibleConstraint = filtrationView.rightAnchor.constraint(equalTo: view.rightAnchor)
        filtersHidenConstraint = filtrationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: view.frame.width * 0.8)
        filtersHidenConstraint?.isActive = true
        
        /*let image = UIImage(named: "filter")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(filterationManagerDisplaingChange))
        navigationItem.rightBarButtonItem = button*/
    }
    @objc func filterationManagerDisplaingChange(){
        filtersVisibleConstraint?.isActive = filtersHiden
        filtersHiden.toggle()
        filtersHidenConstraint?.isActive = filtersHiden
        UIView.animate(withDuration: 0.5, animations: {
            if self.filtersHiden{
                self.filtrationBackground.alpha = 0.0
            }else{
                self.filtrationBackground.alpha = 0.6
            }
            self.view.layoutIfNeeded()
        })
    }
    
    func showFooterButton() {
        if footerHiden{
            footerHiden.toggle()
            footer.setTextAndShow(text: "next page")
            footerHidenBottomConstraint?.isActive = false
            footerVisibleBottomConstraint?.isActive = true
            UIView.animate(withDuration: 0.7, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func hideFooterButton() {
        if !footerHiden{
            footerHiden.toggle()
            footer.hideFooter()
            footerHidenBottomConstraint?.isActive = true
            footerVisibleBottomConstraint?.isActive = false
            UIView.animate(withDuration: 0.7, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc internal func loadNextPage(){
        presenter?.loadNextPage()
    }
    
    internal func setupAddictionalContentMode(){
        reposViewer?.setAddictionalContentMode(mode: .Default)
    }
    
    internal func setupSearchController(){
        guard let owner = presenter as? ReposSearchControllerOwnerProtocol else { return }
        searchController = ReposSearchController(owner: owner)
        searchController?.searchBar.placeholder = NSLocalizedString("Filter repositories", comment: "search controller")
        navigationItem.searchController = searchController
    }
    
    func showReposList() {
        reposViewer?.showReposList()
    }
    
    func reloadCellWithIndex(index: Int) {
        reposViewer?.refreshCell(index: index)
    }
    
    func setFiltersText(filters: [String]){
        for filter in filters{
            filtrationView.filters.addParameter(name: filter, type: .tag, groupTitle: NSLocalizedString("Languages", comment: "filters title"))
        }
        filtrationView.drawUI()
    }
    
    func setScopeBottonsText(buttonsText: [String]) {
        searchController?.setScopeBottonsText(buttonsText: buttonsText)
    }
}


