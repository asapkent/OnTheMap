//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/19/21.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var passwordTextFieldOutlet: UITextField!
    @IBOutlet var loginButtonOutlet: UIButton!
    @IBOutlet var emailTextFieldOutlet: UITextField!
    @IBOutlet var activityIndicatorOutlet: UIActivityIndicatorView!
    @IBOutlet var singupButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radiusForButtons()
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    func radiusForButtons() {
        passwordTextFieldOutlet.layer.cornerRadius = 8
        emailTextFieldOutlet.layer.cornerRadius = 8
        loginButtonOutlet.layer.cornerRadius = 8
    }
}



