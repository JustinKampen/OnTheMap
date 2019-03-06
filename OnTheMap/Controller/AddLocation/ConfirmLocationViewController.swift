//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - ConfirmLocationViewController: UIViewController

class ConfirmLocationViewController: UIViewController {
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var location: String?
    var website: String?
    var coordinate: CLLocationCoordinate2D?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedCorners(finishButton)
        activityIndicator(isDisplayed: true)
        if location != nil {
            geocodeAddress()
        }
    }
    
    // MARK: UI Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        UdacityClient.getUserProfile { (data, error) in
            if data != nil {
                self.handleUserProfileResponse()
            } else {
                self.alert(message: "Unable to load information")
            }
        }
    }
    
    // MARK: Get User Info and perform Post
    
    func handleUserProfileResponse() {
        guard let mediaURL = URL(string: website ?? "") else {
            return
        }
        ParseClient.postStudent(objectId: UdacityClient.UserInfo.key, firstName: UdacityClient.UserInfo.firstName, lastName: UdacityClient.UserInfo.lastName, mapString: location ?? "", mediaURL: mediaURL, latitude: Double(coordinate?.latitude ?? 0.0), longitude: Double(coordinate?.longitude ?? 0.0)) { (success) in
            if success {
                self.alert(message: "Your information has been posted")
            } else {
                self.alert(message: "There was an error while posting your information")
            }
        }
    }
    
    func geocodeAddress() {
        activityIndicator(isDisplayed: true)
        let geocoder = CLGeocoder()
        guard let location = location else {
            return
        }
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            DispatchQueue.main.async {
                guard let placemarks = placemarks else {
                    self.activityIndicator(isDisplayed: false)
                    self.alert(message: "There was a problem searching for the location")
                    return
                }
                if let placemark = placemarks.first, let location = placemark.location {
                    self.coordinate = location.coordinate
                    let mark = MKPlacemark(placemark: placemark)
                    var region = self.mapView.region
                    region.center = location.coordinate
                    region.span.longitudeDelta /= 200
                    region.span.latitudeDelta /= 200
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(mark)
                    self.activityIndicator(isDisplayed: false)
                }
            }
        }
    }
    
    func activityIndicator(isDisplayed: Bool) {
        DispatchQueue.main.async {
            if isDisplayed {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
