//
//  HomeNoDataCollectionViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 06/08/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class HomeNoDataCollectionViewCell: UICollectionViewCell {
    
    //
    // MARK: Properties
    //
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    //
    // MARK: Lifecycle
    //
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTranslations()
        setStyle()
    }
    
    //
    // MARK: Appearance
    //
    
    func setTranslations() {
        noDataLabel.text = "noData.title".localized()
    }
    
    func setStyle() {

        let mainColor = UIColor.lufaGreyColor
        
        imageView.backgroundColor = mainColor
        nameView.backgroundColor = mainColor
        fromView.backgroundColor = mainColor
        toView.backgroundColor = mainColor
        dateView.backgroundColor = mainColor
        background.backgroundColor = UIColor.lufaLightGreyColor
    }
}
