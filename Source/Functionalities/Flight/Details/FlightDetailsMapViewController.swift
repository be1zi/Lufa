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
    
    // MARK: Properties
    @IBOutlet weak var mapView: UIView!

    var flight: Flight?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
    }
    
    // MARK: Appearance
    override func shouldHideNavigationBar() -> Bool {
        return false
    }
    
    override func navigationBarTitle() -> String? {
        return "flight.details.map.title".localized()
    }
    
    // MARK: Data
    func setData() {
        
        guard let flight = flight else {
            return
        }
        
        let cityFrom = LocalRepositoryContext.sharedInstance.getCity(shortCut: flight.departureAirport)
        let cityTo = LocalRepositoryContext.sharedInstance.getCity(shortCut: flight.arrivalAirport)

        guard let from = cityFrom, let to = cityTo else {
            return
        }
        
        let map = configureMap(cityFrom: from, cityTo: to)
        
        mapView.addSubview(map)
    }
    
    func configureMap(cityFrom: City, cityTo: City) -> GMSMapView {
        
        let camera = GMSCameraPosition.camera(withLatitude: cityFrom.latitude, longitude: cityFrom.longitude, zoom: 5)
        let map = GMSMapView.map(withFrame: UIScreen.main.bounds, camera: camera)
        map.isMyLocationEnabled = true
        map.isMyLocationEnabled = true
        
        let locationA = CLLocationCoordinate2D(latitude: cityFrom.latitude, longitude: cityFrom.longitude)
        let markerFrom = GMSMarker(name: "Departure", iconName: "markerA", location: locationA)
        markerFrom.map = map
        
        let locationB = CLLocationCoordinate2D(latitude: cityTo.latitude, longitude: cityTo.longitude)
        let markerTo = GMSMarker(name: "Arrival", iconName: "markerB", location: locationB)
        markerTo.map = map
        
        let bounds = GMSCoordinateBounds(coordinate: markerFrom.position, coordinate: markerTo.position)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        
        map.animate(with: update)
        map.addPathBetweenPoints(pointA: locationA, pointB: locationB)
        
        return map
    }
}
