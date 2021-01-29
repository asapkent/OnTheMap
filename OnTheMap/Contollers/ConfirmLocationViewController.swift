//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/25/21.
//

import UIKit
import MapKit
import CoreLocation

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var confirmLocationButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    var currentUser: UserInfo? = nil

    var newLocation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        handleUserLocation(newCoordinates: newLocation)
    }
    
    @IBAction func confirmLocationAction(_ sender: Any) {
        Client.postUserData(uniqueKey: userInfo.userID, firstName: userInfo.firstName, lastName: userInfo.lastName, mapString: userInfo.mapString, mediaURL: userInfo.mediaURL, latitude: userInfo.latitude, longitude: userInfo.longitude) { (success, error) in
            if success {
                print(userInfo.userID)
                print(success)
                self.navigationController?.dismiss(animated: true, completion: {
                    return
                })
            } else {
                
                self.showPostFailure(message: "Try again.")
            }
        }
    }
    
    func showPostFailure(message: String) {
        
        let alertVC = UIAlertController(title: "Location failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.topMostViewController?.present(alertVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation , reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .yellow
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                let toOpenURL = URL(string: toOpen)
                app.open(toOpenURL!, options: [:]) { (sucesss) in
                    return
                }
            }
        }
    }
    
    func handleUserLocation(newCoordinates: MKAnnotation? ) {
        var pinLocation = [MKPointAnnotation]()
        if let newCoordinates = newCoordinates {
            let pointAnnotation = newCoordinates
            let coordinateRegion = MKCoordinateRegion(center: pointAnnotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(coordinateRegion, animated: true)
            pinLocation.append(pointAnnotation as! MKPointAnnotation)
            self.mapView.addAnnotations(pinLocation)
        } else {
            print("no data")
        }
    }
}
