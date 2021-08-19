//
//  ViewController.swift
//  PointsOfInterest
//
//  Created by elias on 9/8/21.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
        
    // MARK: - Variables And Properties
    var searchResults = try! Realm().objects(POI.self)
    var searchController: UISearchController!
    var pointsOfInterest = try! Realm().objects(POI.self).sorted(byKeyPath: "title", ascending: true)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search Bar
        let searchResultsController = UITableViewController(style: .plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.register(poiCell.self, forCellReuseIdentifier: "POICell")
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = .white
        searchController.searchBar.delegate = self
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        self.loadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailPOI") {
            let controller = segue.destination as! DetailViewController
            var selectedPOI: POI!
            let indexPath = tableView.indexPathForSelectedRow
            
            if isFiltering {
                let searchResultsController =
                    searchController.searchResultsController as! UITableViewController
                let indexPathSearch = searchResultsController.tableView.indexPathForSelectedRow
                
                selectedPOI = searchResults[indexPathSearch!.row]
            } else {
                selectedPOI = pointsOfInterest[indexPath!.row]
            }
            
            controller.pointOfInterest = selectedPOI
        }
    }
    // MARK: - Private Methods
    
    // Search Points of interest with string
    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "title CONTAINS [c]%@", searchString)
        let realm = try! Realm()
        
        searchResults = realm.objects(POI.self).filter(predicate).sorted(byKeyPath: "title", ascending: true)
    }
    
    // Load data from url
    func loadData() {
        let group = DispatchGroup()
        let url = URL(string: "http://t21services.herokuapp.com/points")!
        group.enter()
        URLSession.shared.dataTask(with: url) { data, request, error in
            guard error == nil, let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let list = json["list"] as? [[String:Any]] ?? []
                defer { group.leave() }
                for poi in list {
                    if let id = (poi["id"]! as? NSString)?.intValue {
                        self.getPOIInfo(forId: Int(id), group: group)
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }.resume()
        
        group.notify(queue: .main) {
            self.pointsOfInterest = try! Realm()
                .objects(POI.self)
                .sorted(byKeyPath: "title", ascending: true)
            self.tableView.reloadData()
        }
    }
    
    // Retrieve and Add PointOfInterestDB from url given id
    func getPOIInfo(forId id: Int, group: DispatchGroup) {
        let poiUrl = URL(string: "http://t21services.herokuapp.com/points/\(id)")!
        group.enter()
        URLSession.shared.dataTask(with: poiUrl) { data, request, error in
            defer { group.leave() }
            guard error == nil, let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let realm = try! Realm()
                if (realm.object(ofType: POI.self, forPrimaryKey: id) == nil) {
                    let newPOI = POI(value: json)
                    try! realm.write {
                        realm.add(newPOI)
                    }
                }
            } catch let error as NSError {
                print(error)
            }
        }.resume()
    }
}

// MARK: - Search Bar Delegate
extension TableViewController:  UISearchBarDelegate {
}


// MARK: - Search Results Updatings
extension TableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        if !isSearchBarEmpty {
            filterResultsWithSearchString(searchString: searchString)
            
            let searchResultsController = searchController.searchResultsController as! UITableViewController
            searchResultsController.tableView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = try! Realm().objects(POI.self).filter(NSPredicate(value: false))
        searchBar.text = ""
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

// MARK: - Table View Data Source
extension TableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "POICell") as! poiCell
        let poi = isFiltering ? searchResults[indexPath.row] : pointsOfInterest[indexPath.row]
        cell.titleLabel.text = poi.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? searchResults.count : pointsOfInterest.count
    }
}
