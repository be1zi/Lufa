//
//  GMSMapView+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 02/08/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import GoogleMaps

extension GMSMapView {
    
    func addPathBetweenPoints(pointA: CLLocationCoordinate2D, pointB: CLLocationCoordinate2D) {
        
        let path = GMSMutablePath()
        path.add(pointA)
        path.add(pointB)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .lufaCyanColor
        polyline.strokeWidth = 3.0
        polyline.map = self
    }
}
