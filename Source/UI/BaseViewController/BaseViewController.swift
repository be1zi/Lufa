//
//  BaseViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 22/03/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController {
    
    lazy var progressPresenter: ProgressPresenter? = {
        return ProgressPresenter.init(viewVontroller: self)
    }()
}
