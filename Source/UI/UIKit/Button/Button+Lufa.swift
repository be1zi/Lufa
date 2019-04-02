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
}
