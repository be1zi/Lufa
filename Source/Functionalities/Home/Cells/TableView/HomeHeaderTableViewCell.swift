//
//  HomeHeaderTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 13/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class HomeHeaderTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var messageLabel: UILabel!
    
    func setData(count: Int, type: HomeCellType) {
        
        var format: String = ""
        
        switch type {
        case .TodaysHeader:
            switch count {
            case 1:
                format = "home.flights.number3.title".localized()
            case 2, 3, 4:
                format = "home.flights.number2.title".localized()
            default:
                format = "home.flights.number1.title".localized()
            }
        case .ElseHeader:
            format = "home.flights.more.title".localized()
        default:
            format = "%@"
        }
        
        let text = String.init(format: format, arguments: [count.description])
        
        let range = (text as NSString).range(of: count.description)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lufaCyanColor,
                          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: messageLabel.font.pointSize)]
        
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttributes(attributes, range: range)
        
        messageLabel.attributedText = attributedText
    }
}
