//
//  Button+Lufa.swift
//  Lufa
//
//  Created by Konrad Belzowski on 02/04/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor.init(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
    }
    
//    @IBInspectable var selectedColor: UIColor {
//        set {
//            backgroundColor = UIColor.lufaCyanColor
//        }
//        get {
//            if let backgroundColor = backgroundColor {
//                return backgroundColor
//            } else {
//                return UIColor.clear
//            }
//        }
//    }
}
