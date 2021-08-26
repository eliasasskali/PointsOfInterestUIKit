//
//  POIDetailProtocols.swift
//  PointsOfInterest
//
//  Created by elias on 26/8/21.
//

import Foundation
import UIKit

protocol POIDetailViewControllerInterface: AnyObject {
    // Presenter -> View
    func showPOIDetail(with poi: POI)
}

protocol POIDetailPresenterInterface: AnyObject {
    var router: POIDetailRouterInterface? { get set }
    var view: POIDetailViewControllerInterface? { get set }
    
    func getPOI() -> POI
    // View -> Presenter
    func notifyViewLoaded()
}

protocol POIDetailRouterInterface: AnyObject {

}
