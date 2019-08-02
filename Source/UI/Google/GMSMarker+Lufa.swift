//
//  GMSMarker+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 02/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import GoogleMaps

extension GMSMarker {
    
    public convenience init(name: String, iconName: String, location: CLLocationCoordinate2D) {
        self.init()
        position = location
        title = name.localized()
        icon = UIImage(named: iconName)
        setIconSize(scaledToSize: CGSize(width: 50, height: 50))
    }
    
    func setIconSize(scaledToSize newSize: CGSize) {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        icon = newImage
    }
}
