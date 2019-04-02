//
//  AuthorizationViewController.swift
//  Lufa
//
//  Created by Konrad Belzowski on 01/04/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import UIKit

class AuthorizationViewController: BaseViewController {
    
    @IBOutlet weak var authorizeButton: UIButton!
    
    //MARK: Actions
    
    @IBAction func authorizeButtonAction(_ sender: UIButton) {
        
        progressPresenter?.presentProgress(withText: nil, completion: {
            RemoteRepositoryContext.sharedInstance.authorize(withSuccess: { result in
                
                let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController()?.children.first
                
                guard let viewController = vc else {
                    return
                }
                
                self.navigationController?.pushViewController(viewController, animated: true)
                
                self.progressPresenter?.hideProgress()
            }) { error in
                print("Error authorization: \(error?.localizedDescription ?? "empty message")")
                self.progressPresenter?.hideProgress()
            }
        })
    }
}
