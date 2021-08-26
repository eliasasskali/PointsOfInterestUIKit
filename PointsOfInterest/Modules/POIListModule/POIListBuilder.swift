//
//  POIListBuilder.swift
//  PointsOfInterest
//
//  Created by elias on 25/8/21.
//

import Foundation
import UIKit

class POIListBuilder {
    class func createPOIListModule(poiListRef: POIListViewController) {
       let presenter: POIListPresenterInterface = POIListPresenter()
        
        poiListRef.presenter = presenter
        poiListRef.presenter?.router = POIListRouter()
        poiListRef.presenter?.view = poiListRef
        poiListRef.presenter?.interactor = POIListInteractor()
        poiListRef.presenter?.interactor?.presenter = presenter
    }
}
