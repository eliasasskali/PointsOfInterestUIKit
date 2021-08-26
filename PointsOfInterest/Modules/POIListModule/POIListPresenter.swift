//
//  POIListPresenter.swift
//  PointsOfInterest
//
//  Created by elias on 23/8/21.
//

import UIKit

class POIListPresenter {
    weak var view: POIListViewInterface?
    var router: POIListRouterInterface?
    var interactor: POIListInteractorInterface?
    
    var poiViewModels: [POI]?
    var poiSearchResults: [POI]?
    
    let kPageTitle = "Points of Interest"
}

extension POIListPresenter: POIListPresenterInterface {
    func isSearching(with searchString: String) {
        interactor?.filterResultsWithSearchString(searchString: searchString)
    }
    
    func notifyViewLoaded() {
        view?.setupInitialView()
        view?.showLoading()
        interactor?.fetchPOIList()
    }
    
    func notifyViewWillAppear() {
        view?.setScreenTitle(with: kPageTitle)
    }
    
    func poiSelected(with poi: POI, from view: UIViewController) {
        router?.pushToPOIDetail(with: poi, from: view)
    }
    
    func poiListFetched(poiList: [POI]) {
        self.poiViewModels = poiList
        view?.hideLoading()
        view?.reloadData()
    }
    
    func poiSearchResultsFetched(poiList: [POI]) {
        self.poiSearchResults = poiList
        view?.reloadData()
    }
    
    func poiListFetchFailed(with errorMessage: String) {
        router?.presentPopup(with: errorMessage)
    }
    
    func getPOIViewModels() -> [POI] {
        return poiViewModels ?? []
    }
    
    func getPOISearchResults() -> [POI] {
        return poiSearchResults ?? []
    }
}
