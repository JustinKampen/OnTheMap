//
//  Extensions.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// MARK: - UIViewController Extensions

extension UIViewController {
    
    // MARK: Present Alert
    
    func presentAlert(_ message: String = "There was a problem performing that action.") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Round Button Corners
    
    func roundedCorners(_ item: UIView) {
        item.layer.masksToBounds = true
        item.layer.cornerRadius = 5.0
    }
    
    // MARK: Logout UI Action
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
