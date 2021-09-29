//
//  POIDetailPresenter.swift
//  PointsOfInterest
//
//  Created by elias on 26/8/21.
//

import Foundation
import UIKit

class POIDetailPresenter: POIDetailPresenterInterface {
    var router: POIDetailRouterInterface?
    weak var view: POIDetailViewControllerInterface?
    var poi: POI?
    
    func notifyViewLoaded() {
        view?.showPOIDetail(with: poi!)
    }
    
    func getPOI() -> POI {
        if let poi = poi {
            return poi
        }
        else {
            return POI()
        }
    }
    
}
