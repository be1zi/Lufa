//
//  SearchTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 16/07/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

enum SearchImageType {
    case clock
    case search
    
    func image() -> UIImage? {
        
        switch self {
        case .clock:
            return UIImage(named: "lastViewed")
        case .search:
            return UIImage(named: "search")
        }
    }
}

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: Lifecycle
    func load(withName name: String, typedText text: String, imageType: SearchImageType) {
        nameLabel.attributedText = attributedString(withName: name, typedText: text)
        iconImageView.image = imageType.image()
    }
    
    // MARK: Helper
    func attributedString(withName name: String, typedText text: String) -> NSAttributedString {
        
        let range = (name.uppercased() as NSString).range(of: text.uppercased())
        
        let attributedString = NSMutableAttributedString.init(string: name)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        
        return attributedString
    }
}
