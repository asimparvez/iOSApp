//
//  BaseViewController.swift
//  iOSApp
//
//  Created by Asim Parvez on 9/17/18.
//  Copyright © 2018 Asim Parvez. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage


class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - Show Alert
    func showErrorAlert(message:String!, title:String!)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - HUD/Activity Indicator
    func showActivityIndicator() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
