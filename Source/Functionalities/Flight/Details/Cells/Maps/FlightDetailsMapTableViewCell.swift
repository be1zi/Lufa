//
//  FlightDetailsMapTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 19/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class FlightDetailsMapTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var mapView: UIView!
    
    var fromCity: City?
    var toCity: City?
    
    //MARK: Lifecycle
    func loadWithCity(from: City?, to: City?) {
        fromCity = from
        toCity = to
        
        setData()
    }

    
    func setData() {
        
        guard let from = fromCity, let to = toCity else {
            return
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: from.latitude, longitude: from.longitude, zoom: 5)
        let map = GMSMapView.map(withFrame: mapView.frame, camera: camera)
        map.isUserInteractionEnabled = false
        map.isMyLocationEnabled = false
        
        let locationFrom = CLLocationCoordinate2D(latitude: from.latitude, longitude: from.longitude)
        let markerFrom = GMSMarker(position: locationFrom)
        markerFrom.title = "Departure"
        markerFrom.map = map
        
        let locationTo = CLLocationCoordinate2D(latitude: to.latitude, longitude: to.longitude)
        let markerTo = GMSMarker(position: locationTo)
        markerTo.title = "Arrival"
        markerTo.map = map
        
        mapView.addSubview(map)
    }
}
