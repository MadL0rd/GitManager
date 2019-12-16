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
    
    internal var searchController: (UISearchController & SearchControllerProtocol)?
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
        setupLoading()
        
        setupInheritor()
    }
    
    internal func setupInheritor(){
        
    }
    
    func layoutRefresh(){
        UIView.animate(withDuration: 0, animations: {
            self.view.layoutIfNeeded()
        })
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
        reposView.setMargin(0)
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
        filtrationBackground.setMargin(baseView: view.safeAreaLayoutGuide, 0)
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
        loading.setMargin(0)
        loading.show(animation: false)
    }
    
    @objc func filterationManagerDisplaingChange(){
        if filtersHiden {
            filtersHidenConstraint?.isActive = false
            filtersVisibleConstraint?.isActive = true
        } else {
            filtersVisibleConstraint?.isActive = false
            filtersHidenConstraint?.isActive = true
        }
        filtersHiden.toggle()
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
        guard let owner = presenter as? SearchControllerOwnerProtocol else { return }
        searchController = SearchController(owner: owner, searchResultsController: self)
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


