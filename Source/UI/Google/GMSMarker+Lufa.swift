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
    
    func setIconSize(scaledToSize newSize: CGSize) {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        icon = newImage
    }
}
