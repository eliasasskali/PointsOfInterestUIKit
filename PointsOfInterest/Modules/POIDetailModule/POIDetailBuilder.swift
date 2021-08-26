//
//  POIDetailBuilder.swift
//  PointsOfInterest
//
//  Created by elias on 26/8/21.
//

import Foundation
import UIKit

class POIDetailBuilder {
    class func createPOIDetailModule(with poiDetailRef: POIDetailViewController, and poi: POI) {
        let presenter = POIDetailPresenter()
        presenter.poi = poi
        poiDetailRef.presenter = presenter
        poiDetailRef.presenter?.view = poiDetailRef
        poiDetailRef.presenter?.router = POIDetailRouter()
    }
}
