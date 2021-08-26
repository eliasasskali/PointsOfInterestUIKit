//
//  POIListViewController.swift
//  PointsOfInterest
//
//  Created by elias on 23/8/21.
//

import Foundation
import UIKit

class POIListViewController: UITableViewController, POIListViewInterface {
    var presenter: POIListPresenterInterface?
    var searchController: UISearchController?
    
    var isSearchBarEmpty: Bool {
        return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController?.isActive ?? false && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        POIListBuilder.createPOIListModule(poiListRef: self)
        presenter?.notifyViewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.notifyViewWillAppear()
    }
    
    func setupInitialView() {
        // Search Bar
        let searchResultsController = UITableViewController(style: .plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.register(poiCell.self, forCellReuseIdentifier: "POICell")
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.tintColor = .white
        searchController?.searchBar.delegate = self
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    func setScreenTitle(with title: String) {
        self.title = title
    }
    
    func showLoading() {
        print("Loading")
    }
    
    func hideLoading() {
        print("Loaded")
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
}

// MARK: - Table View
extension POIListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "POICell") as! poiCell
        let poi = isFiltering ? presenter?.getPOISearchResults()[indexPath.row] : presenter?.getPOIViewModels()[indexPath.row]
        
        cell.titleLabel.text = poi?.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return presenter?.getPOISearchResults().count ?? 0
        }
        else {
            return presenter?.getPOIViewModels().count ?? 0
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poi = isFiltering ? presenter?.getPOISearchResults()[indexPath.row] : presenter?.getPOIViewModels()[indexPath.row]
        presenter?.poiSelected(with: poi!, from: self)
    }
}

// MARK: - Search Bar Delegate
extension POIListViewController:  UISearchBarDelegate {
}


// MARK: - Search Results Updatings
extension POIListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        if !isSearchBarEmpty {
            presenter?.isSearching(with: searchString)
            
            let searchResultsController = searchController.searchResultsController as! UITableViewController
            searchResultsController.tableView.reloadData()
        }
        else {
            self.tableView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}
