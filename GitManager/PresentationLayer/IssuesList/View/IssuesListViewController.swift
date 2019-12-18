//
//  IssuesListViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 06.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class IssuesListViewController: UIViewController, IssuesListViewProtocol, UITableViewDataSource, UITableViewDelegate{
    
    var presenter: IssuesListPresenterProtocol?
    
    private var searchController: (UISearchController & SearchControllerProtocol)?
    private let footer = SearchFooterButton()
    private var footerHidenBottomConstraint : NSLayoutConstraint?
    private var footerVisibleBottomConstraint : NSLayoutConstraint?
    private var footerHiden = true
    private let filtrationView: FiltersViewProtocol = FiltersView()
    private let filtrationBackground = UIButton()
    private var filtersHidenConstraint : NSLayoutConstraint?
    private var filtersVisibleConstraint : NSLayoutConstraint?
    private var filtersHiden = true
    private let filtersControlButton = UIButton()
    private var loading: LoadingViewProtocol = LoadingView()
    private var tableViewIssues = UITableView()
    private let refreshControl = UIRefreshControl()
    private let noContentView = NoContentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal func setupView(){
        self.hideKeyboardWhenTappedAround()

        setupNavigation()
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
    
    internal func setupNavigation(){
        navigationItem.title = NSLocalizedString("Issues", comment: "navigation title")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(createIssue))
    }
    
    @objc private func createIssue(){
        showInputDialog(title: NSLocalizedString("Add issue", comment: "input dialog"),
                        subtitle: NSLocalizedString("Type title for new issue", comment: "input dialog"),
                        inputPlaceholder: NSLocalizedString("Title for issue", comment: "input dialog"),
                        inputKeyboardType: .default)
        { (input:String?) in
            if let title = input {
                self.presenter?.createIssue(title: title)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showIssuePage(index: indexPath.row)
    }
    
    func showIssuesList() {
        hideLoadingView()
        refreshControl.endRefreshing()
        tableViewIssues.reloadData()
    }
    
    func setFiltersText(filters: [String]) {
        
    }
    
    private func setupTableView() {
        if #available(iOS 10.0, *) {
            tableViewIssues.refreshControl = refreshControl
        } else {
            tableViewIssues.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = Colors.mainColor
        
        view.addSubview(tableViewIssues)
        tableViewIssues.translatesAutoresizingMaskIntoConstraints = false
        tableViewIssues.setMargin(0)
        tableViewIssues.dataSource = self
        tableViewIssues.delegate = self
        tableViewIssues.register(IssueTableViewCell.self, forCellReuseIdentifier: "issueCell")
        tableViewIssues.backgroundColor = Colors.mainBackground
        
        view.addSubview(noContentView)
        noContentView.setMargin(baseView: view.safeAreaLayoutGuide, 0)
    }
    
    @objc private func refresh(){
        presenter?.reloadData()
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
        filtrationBackground.setMargin(baseView: view?.safeAreaLayoutGuide, 0)
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
        
        let state = NSLocalizedString("State", comment: "Issues filters title")
        let open = NSLocalizedString("Open", comment: "Issues filter")
        let closed = NSLocalizedString("Closed", comment: "Issues filter")
        filtrationView.filters.addParameter(name: closed, type: .tag, groupTitle: state)
        filtrationView.filters.addParameter(name: open, type: .tag, groupTitle: state)
        filtrationView.filters.setTagParameterState(name: closed, groupTitle: state, value: false)
        filtrationView.drawUI()
        presenter?.applyFilters(filtrationManager: filtrationView.filters)
    }
    
    private func setupLoading(){
        view.addSubview(loading)
        loading.setMargin(0)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            presenter?.scrollContentEnds()
        }else{
            presenter?.scrollContentNotEnds()
        }
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
        //reposViewer?.setAddictionalContentMode(mode: .Default)
    }
    
    internal func setupSearchController(){
        guard let owner = presenter as? SearchControllerOwnerProtocol else { return }
        searchController = SearchController(owner: owner, searchResultsController: self)
        searchController?.searchBar.placeholder = NSLocalizedString("Filter issues", comment: "search controller")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter?.getItemsCount() ?? 0
        if count == 0 {
            noContentView.show()
        } else {
            noContentView.hide()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IssueTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath) as! IssueTableViewCell
        if let issue = presenter?.getItemWithIndex(index: indexPath.row){
            cell.setIssue(issue: issue)
        }
        return cell
    }
}
