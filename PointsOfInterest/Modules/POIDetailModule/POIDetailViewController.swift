//
//  DetailViewController.swift
//  PointsOfInterest
//
//  Created by elias on 10/8/21.
//

import Foundation
import UIKit
import MapKit

class POIDetailViewController: UITableViewController, POIDetailViewControllerInterface {
    var presenter: POIDetailPresenterInterface?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var descriptionCell: UITableViewCell!
    @IBOutlet weak var mailCell: UITableViewCell!
    @IBOutlet weak var phoneCell: UITableViewCell!
    @IBOutlet weak var transportCell: UITableViewCell!
    @IBOutlet weak var addressCell: UITableViewCell!
    
    var poi: POI?
    
    func showPOIDetail(with poi: POI) {
        titleLabel.text = poi.title
        coordinatesLabel.text = poi.geocoordinates
        
        if let description = poi.desc {
            descriptionLabel.text = description
        }
        if let email = poi.email {
            emailLabel.text = email
        }
        if let phone = poi.phone {
            phoneLabel.text = phone
        }
        if let address = poi.address {
            addressLabel.text = address
        }
        if let transport = poi.transport {
            transportLabel.text = transport
        }
        
        // Center and add pin of POI in map
        centerAndPinMapOnLocation(poi: poi, mapView: mapView)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        poi = presenter?.getPOI()
        presenter?.notifyViewLoaded()
    }
    
    func centerAndPinMapOnLocation(poi: POI, mapView: MKMapView) {
        let latlong = poi.geocoordinates.split(separator: ",")
        let latitude = Double(latlong[0])!
        let longitude = Double(latlong[1])!
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = centerCoordinate
        annotation.title = poi.title
        annotation.subtitle = poi.address
        mapView.addAnnotation(annotation)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            if poi?.desc == nil {
                return 0
            }
        case 2:
            if poi?.email == nil {
                return 0
            }
        case 3:
            if poi?.phone == nil {
                return 0
            }
        case 4:
            if poi?.transport == nil {
                return 0
            }
        case 5:
            if poi?.address == nil {
                return 0
            }
        default:
            print("None")
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
}
