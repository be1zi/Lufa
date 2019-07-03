//
//  FlightDetailsMapViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 02/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class FlightDetailsMapViewController: BaseViewController {
    
    //MARK: Properties
    @IBOutlet weak var mapView: UIView!

    var flight: Flight?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setData()
    }
    
    //MARK: Appearance
    override func shouldHideNavigationBar() -> Bool {
        return false
    }
    
    override func navigationBarTitle() -> String? {
        return "flight.details.map.title".localized()
    }
    
    //MARK: Data
    func setData() {
        
        guard let flight = flight else {
            return
        }
        
        let cityFrom = LocalRepositoryContext.sharedInstance.getCityName(shortCut: flight.departureAirport)
        let cityTo = LocalRepositoryContext.sharedInstance.getCityName(shortCut: flight.arrivalAirport)

        guard let from = cityFrom, let to = cityTo else {
            return
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: from.latitude, longitude: from.longitude, zoom: 5)
        let map = GMSMapView.map(withFrame: UIScreen.main.bounds, camera: camera)
        map.isMyLocationEnabled = true
        map.isMyLocationEnabled = true
        
        let locationFrom = CLLocationCoordinate2D(latitude: from.latitude, longitude: from.longitude)
        let markerFrom = GMSMarker(position: locationFrom)
        markerFrom.title = "Departure"
        markerFrom.icon = UIImage(named: "markerA")
        markerFrom.setIconSize(scaledToSize: CGSize(width: 50, height: 50))
        markerFrom.map = map
        
        let locationTo = CLLocationCoordinate2D(latitude: to.latitude, longitude: to.longitude)
        let markerTo = GMSMarker(position: locationTo)
        markerTo.title = "Arrival"
        markerTo.icon = UIImage(named: "markerB")
        markerTo.setIconSize(scaledToSize: CGSize(width: 50, height: 50))
        markerTo.map = map
        
        mapView.addSubview(map)
    }
}
