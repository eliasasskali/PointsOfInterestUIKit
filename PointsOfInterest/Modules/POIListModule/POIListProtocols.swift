//
//  POIListProtocols.swift
//  PointsOfInterest
//
//  Created by elias on 25/8/21.
//

import Foundation
import UIKit

protocol POIListViewInterface: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func setupInitialView()
    func setScreenTitle(with title: String)
}

protocol POIListPresenterInterface: AnyObject {
    var view: POIListViewInterface? { get set }
    var router: POIListRouterInterface? { get set }
    var interactor: POIListInteractorInterface? { get set }
    
    // POIListView -> POIListPresenter
    func notifyViewLoaded()
    func notifyViewWillAppear()
    func poiSelected(with poi: POI, from view: UIViewController)
    func isSearching(with searchString: String)
    
    // POIListInteractor -> POIListPresenter
    func poiListFetched(poiList: [POI])
    func poiListFetchFailed(with errorMessage: String)
    func poiSearchResultsFetched(poiList: [POI])
    
    func getPOIViewModels() -> [POI]
    func getPOISearchResults() -> [POI]
}

protocol POIListInteractorInterface: AnyObject {
    var presenter: POIListPresenterInterface? { get set }
    // POIListPresenter -> POIListInteractor
    func fetchPOIList()
    func filterResultsWithSearchString(searchString: String)
}

protocol POIListRouterInterface: AnyObject {
    // POIListPresenter -> POIListRouter
    func popBack()
    func pushToPOIDetail(with poi: POI, from view: UIViewController)
    func presentPopup(with message: String)
}
