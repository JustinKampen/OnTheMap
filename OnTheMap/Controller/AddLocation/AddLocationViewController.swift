//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// MARK: - AddLocationViewController: UIViewController

class AddLocationViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedCorners(findLocationButton)
    }
    
    // MARK: UI Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        if locationTextField.text == "" && websiteTextField.text == "" {
            presentAlert("Please enter a valid location and website")
        } else if locationTextField.text == "" {
            presentAlert("Please enter a valid location")
        } else if websiteTextField.text == "" {
            presentAlert("Please enter a valid website")
        } else {
            performSegue(withIdentifier: "confirmLocation", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ConfirmLocationViewController
        controller.location = locationTextField.text ?? ""
        controller.website = websiteTextField.text ?? ""
    }
}

// MARK: - AddLocationViewController: UITextFieldDelegate

extension AddLocationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
}
