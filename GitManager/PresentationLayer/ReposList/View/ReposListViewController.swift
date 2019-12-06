//
//  ReposListView.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListViewController: UIViewController, ReposListViewProtocol{
    
    var presenter: ReposListPresenterProtocol?
    var reposViewer: ReposTableViewer?
    
    internal var searchController: (UISearchController & ReposSearchControllerProtocol)?
    internal let footer = SearchFooterButton()
    internal var footerHidenBottomConstraint : NSLayoutConstraint?
    internal var footerVisibleBottomConstraint : NSLayoutConstraint?
    internal var footerHiden = true
    internal let filtrationView: FiltersViewProtocol = FiltersView()
    internal let filtrationBackground = UIButton()
    internal var filtersHidenConstraint : NSLayoutConstraint?
    internal var filtersVisibleConstraint : NSLayoutConstraint?
    internal var filtersHiden = true
    internal let filtersControlButton = UIButton()
    internal var loading: LoadingViewProtocol = LoadingView()
    
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
        setupSwipes()
        setupFilterationManagerView()
        setupRefreshControl()
        setupLoading()
        
        setupInheritor()
    }
    
    internal func setupInheritor(){
        
    }
    
    internal func setupNavigationTitle(){
        navigationItem.title = NSLocalizedString("My repositories", comment: "Title on repositories screen")
    }
    
    internal func setupRefreshControl() {

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
        view.addSubview(filtersControlButton)
        filtrationBackground.translatesAutoresizingMaskIntoConstraints = false
        filtrationBackground.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        filtrationBackground.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        filtrationBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filtrationBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        filtrationBackground.backgroundColor = Colors.disable
        filtrationBackground.alpha = 0
        filtrationBackground.addTarget(self, action: #selector(filterationManagerDisplaingChange), for: .touchUpInside)
        
        filtrationView.setApplyAction {
            self.filterationManagerDisplaingChange()
            self.presenter?.applyFilters(filtrationManager: self.filtrationView.filters)
        }
        view.addSubview(filtrationView)
        filtrationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filtrationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        filtrationView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        filtersVisibleConstraint = filtrationView.rightAnchor.constraint(equalTo: view.rightAnchor)
        filtersHidenConstraint = filtrationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: view.frame.width * 0.8)
        filtersHidenConstraint?.isActive = true
        
        filtersControlButton.setTitle("<", for: .normal)
        filtersControlButton.addTarget(self, action: #selector(filterationManagerDisplaingChange), for: .touchUpInside)
        Designer.smallButton(filtersControlButton)
        filtersControlButton.alpha = 0.8
        filtersControlButton.rightAnchor.constraint(equalTo: filtrationView.leftAnchor, constant: 7).isActive = true
        filtersControlButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupLoading(){
        view.addSubview(loading)
        
        loading.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loading.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loading.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loading.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        loading.show(animation: false)
    }
    
    @objc func filterationManagerDisplaingChange(){
        filtersVisibleConstraint?.isActive = filtersHiden
        filtersHiden.toggle()
        filtersHidenConstraint?.isActive = filtersHiden
        UIView.animate(withDuration: 0.5, animations: {
            if self.filtersHiden{
                self.filtrationBackground.alpha = 0.0
                self.filtersControlButton.setTitle("<", for: .normal)
            }else{
                self.filtrationBackground.alpha = 0.6
                self.filtersControlButton.setTitle(">", for: .normal)
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
    
    func hideLoadingView() {
        loading.hide()
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
    
    internal func setupSwipes(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            if !filtersHiden{
                filterationManagerDisplaingChange()
            }
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            if filtersHiden{
                filterationManagerDisplaingChange()
            }
        }
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


