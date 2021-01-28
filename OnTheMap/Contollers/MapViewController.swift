//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/22/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapViewOutlet: MKMapView!
    @IBOutlet var logoutButtonOutlet: UIBarButtonItem!
    @IBOutlet var addButtonOutlet: UIBarButtonItem!
    @IBOutlet var refreshButtonOutlet: UIBarButtonItem!
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewOutlet.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleStudentData()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        Client.deleteSession { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        handleStudentData()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation , reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .yellow
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
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
                if openURL(toOpen) {
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                } else {
                    print(view.annotation?.subtitle! ?? "No URL")
                    return
                }
            }
        }
    }
    
    func handleStudentData() {
        self.annotations = []
        mapViewOutlet.removeAnnotations(mapViewOutlet.annotations)
        Client.getStudentData() { (data: StudentData?, error: Error?) in
            if let error = error {
                let networkError = LoginErrorResponse (status: 99, error: "Network issues")
                DispatchQueue.main.async {
                    self.showError(message: "Network issues")
                }
                return
            } else if data != nil {
                for student in data!.results {
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(student.latitude), CLLocationDegrees(student.longitude))
                    pointAnnotation.title = "\(student.firstName) \(student.lastName)"
                    pointAnnotation.subtitle = "\(student.mediaURL)"
                    self.annotations.append(pointAnnotation)
                }
                self.mapViewOutlet.addAnnotations(self.annotations)
            } else {
                self.showError(message: "Please Try Again Later")
            }
        }
    }
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Refresh Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func openURL(_ string: String?) -> Bool {
        guard let urlString = string,
              let url = URL(string: urlString)
        else { return false }
        
        if !UIApplication.shared.canOpenURL(url) { return false }
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
}
