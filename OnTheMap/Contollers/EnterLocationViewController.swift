//
//  EnterLocationViewController.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/25/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class EnterLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var locationTextField: UITextField!
    
    @IBOutlet var personalLinkTextField: UITextField!
    
    @IBOutlet var findLoactionButtonOutlet: UIButton!
    
    @IBOutlet var cancelButtonOutlet: UIBarButtonItem!
    
    @IBOutlet var activityIndicatorOutlet: UIActivityIndicatorView!
    
    var placeMark = [CLPlacemark?]()
    var newCoordinates: MKPointAnnotation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationTextField.delegate = self
        self.personalLinkTextField.delegate = self
        activityIndicatorOutlet.isHidden = true
    }
    
  
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        let location = locationTextField.text ?? ""
        locationSearch(true)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [self] (data: [CLPlacemark]?, error: Error?) in
            if let data = data {
                self.placeMark = data
                if let newPlacemark = self.placeMark[0] {
                    locationSearch(false)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newPlacemark.location!.coordinate
                    self.newCoordinates = annotation
                    userInfo.latitude = Float(self.newCoordinates!.coordinate.latitude)
                    userInfo.longitude = Float(self.newCoordinates!.coordinate.longitude)
                    userInfo.mediaURL = personalLinkTextField.text ?? ""
                    self.performSegue(withIdentifier: "showDetail", sender: nil)
                    
                } else {
                    locationSearch(false)
                    return
                }
                
            } else {
                if data == nil {
                    locationSearch(false)
                    showDataFailure(message: " Location no found")
                } else if personalLinkTextField.text == ""{
                    showDataFailure(message: "Enter URL")
                }
                
            }
            
        }
    }
    
    func geocodeAddressString(_ addressString: String,
                              completionHandler: @escaping ([CLPlacemark]?, Error?) -> Void) {
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == locationTextField) {
            textField.text = ""
        }
        else if (textField == personalLinkTextField) {
            textField.text = ""
        }
    }
    
    func showDataFailure(message: String) {
        
        let alertVC = UIAlertController(title: "GeoCoding Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
        UIApplication.topMostViewController?.present(alertVC, animated: true, completion: nil)
        
    }
    
    func locationSearch(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicatorOutlet.isHidden = false
            activityIndicatorOutlet.startAnimating()
        } else {
            activityIndicatorOutlet.stopAnimating()
            activityIndicatorOutlet.isHidden = true
        }
        locationTextField.isEnabled = !loggingIn
        personalLinkTextField.isEnabled = !loggingIn
        findLoactionButtonOutlet.isEnabled = !loggingIn
        
    }
    
    
}


extension UIApplication {
    static var topMostViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.visibleViewController
    }
}

extension UIViewController {
        var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else {
            return self
        }
    }
}


