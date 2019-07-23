//
//  UIColor+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 30/05/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func colorWithHex(color: String, alpha: CGFloat?) -> UIColor {
        
        var colorString: String = color.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if colorString.hasPrefix("#") {
            colorString.remove(at: colorString.startIndex)
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbValue)
        
        var a: CGFloat = 1.0
        
        if let alpha = alpha {
            a = alpha
        }
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat((rgbValue & 0x0000FF)) / 255.0,
                       alpha: a)
    }
    
    static var lufaCyanColor: UIColor {
        return UIColor.colorWithHex(color: "#00cfd1", alpha: nil)
    }
    
    static var lufaWhiteColor: UIColor {
        return UIColor.colorWithHex(color: "#ffffff", alpha: 0.25)
    }
    
    static var lufaGreenColor: UIColor {
        return UIColor.colorWithHex(color: "#CEDC00", alpha: nil)
    }
    
    static var lufaGreyColor: UIColor {
        return UIColor.colorWithHex(color: "#8A8A8A", alpha: nil)
    }
}
