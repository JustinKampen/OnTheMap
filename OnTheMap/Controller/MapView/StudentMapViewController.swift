//
//  StudentMapViewController.swift
//  OnTheMap
//
//  Created by Justin Kampen on 2/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import MapKit

// MARK: - StudentMapViewController: UIViewController

class StudentMapViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var students = [StudentInformaiton]() {
        didSet {
            populateMap()
        }
    }

    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        refreshStudents()
        populateMap()
    }
    
    // MARK: UI Actions
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        activityIndicator(isDisplayed: true)
        getStudents()
    }
    
    // MARK: Get and Refresh Students
    
    func refreshStudents() {
        activityIndicator(isDisplayed: true)
        getStudents()
    }
    
    func getStudents(reload: Bool = true) {
        if reload {
            Students.shared.refreshStudents { (students, error) in
                self.activityIndicator(isDisplayed: false)
                DispatchQueue.main.async {
                    guard let students = students else {
                        self.presentAlert("Failed to load students")
                        return
                    }
                    self.students = students
                }
            }
        } else {
            students = Students.shared.all
            activityIndicator(isDisplayed: false)
        }
    }
    
    func populateMap() {
        var annotations = [MKPointAnnotation]()
        for student in students {
            let latitude = Double(student.latitude)
            let longitude = Double(student.longitude)
            if latitude == 0.0 || longitude == 0.0 {
                continue
            }
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let firstName = student.firstName
            let lastName = student.lastName
            let mediaURL = student.mediaURL
            if firstName == "" || lastName == "" || mediaURL == nil {
                continue
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL?.absoluteString ?? ""
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
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

// MARK: - StudentMapViewController: MKMapViewDelegate

extension StudentMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.tintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle, let urlToOpen = URL(string: toOpen!) {
                UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
            }
        }
    }
}
