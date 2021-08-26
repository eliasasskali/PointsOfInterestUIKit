//
//  POIListInteractor.swift
//  PointsOfInterest
//
//  Created by elias on 23/8/21.
//

import Foundation
import UIKit
import RealmSwift

class POIListInteractor {
    weak var presenter: POIListPresenterInterface?
    
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
                self.presenter?.poiListFetchFailed(with: error.description)
            }
        }.resume()
        
        group.notify(queue: .main) {
            let pointsOfInterest = try! Realm()
                .objects(POI.self)
                .sorted(byKeyPath: "title", ascending: true)
            
            self.presenter?.poiListFetched(poiList: Array(pointsOfInterest))
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

extension POIListInteractor: POIListInteractorInterface {
    func fetchPOIList() {
        self.loadData()
    }
    
    func filterResultsWithSearchString(searchString: String) {
        do {
            let predicate = NSPredicate(format: "title CONTAINS [c]%@", searchString)
            let realm = try! Realm()
            
            let searchResults = realm.objects(POI.self).filter(predicate).sorted(byKeyPath: "title", ascending: true)
            
            presenter?.poiSearchResultsFetched(poiList: Array(searchResults))
        }
    }
}
