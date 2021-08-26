//
//  POIListRouter.swift
//  PointsOfInterest
//
//  Created by elias on 23/8/21.
//

import Foundation
import UIKit

class POIListRouter {
    var presenter: POIListPresenter?
    var viewController: POIListViewController?
}

extension POIListRouter: POIListRouterInterface {
    func popBack() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
    func pushToPOIDetail(with poi: POI, from view: UIViewController) {
        let poiDetailViewController = view.storyboard?.instantiateViewController(withIdentifier: "POIDetailView") as! POIDetailViewController
        POIDetailBuilder.createPOIDetailModule(with: poiDetailViewController, and: poi)
        view.navigationController?.pushViewController(poiDetailViewController, animated: true)
    }
    
    func presentPopup(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Allright", style: .default, handler: nil))
        self.viewController?.navigationController?.visibleViewController?.present(alertController, animated: true, completion: nil)
    }
}
