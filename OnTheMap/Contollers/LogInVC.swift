//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Robert Jeffers on 1/19/21.
//

import UIKit
import FBSDKLoginKit

class LoginVC: UIViewController {

    @IBOutlet var passwordTextFieldOutlet: UITextField!
    @IBOutlet var loginButtonOutlet: UIButton!
    @IBOutlet var emailTextFieldOutlet: UITextField!
    @IBOutlet var activityIndicatorOutlet: UIActivityIndicatorView!
    @IBOutlet var singupButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radiusForButtons()
        clearTextFields()
        observer()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        let url = URL(string: "https://auth.udacity.com/sign-up")
        UIApplication.shared.open(url!)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        setLoggingIn(true)
        Client.login(username: emailTextFieldOutlet.text ?? "", password: passwordTextFieldOutlet.text ?? "") { (success, error) in
            if success?.account.key != nil {
                self.setLoggingIn(false)
                Client.getUserData { (success, error) in
                    self.passwordTextFieldOutlet.text = ""
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                } } else if AccessToken.current?.tokenString != nil {
                        self.performSegue(withIdentifier: "completeLogin", sender: nil)
                    self.setLoggingIn(false)
                        return
                    }
                    else {
                self.setLoggingIn(false)
                let errorResponse = error!.error
                self.loginFailureMessage(message: errorResponse)
            }
        }
    }
    
    func radiusForButtons() {
        passwordTextFieldOutlet.layer.cornerRadius = 8
        emailTextFieldOutlet.layer.cornerRadius = 8
        loginButtonOutlet.layer.cornerRadius = 8
    }
    
    func LoginFailureMessage(message: String) {
        setLoggingIn(false)
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicatorOutlet.startAnimating()
        } else {
            activityIndicatorOutlet.stopAnimating()
        }
        emailTextFieldOutlet.isEnabled = !loggingIn
        passwordTextFieldOutlet.isEnabled = !loggingIn
        loginButtonOutlet.isEnabled = !loggingIn
    }
    
    func loginFailureMessage(message: String) {
        setLoggingIn(false)
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func clearTextFields() {
        emailTextFieldOutlet.text = ""
        passwordTextFieldOutlet.text = ""
    }
    
    func observer() {
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            if AccessToken.current?.tokenString != nil {
                self.setLoggingIn(false)
            } else {
                self.setLoggingIn(false)
                self.loginFailureMessage(message: "Can not connect to Facebook")
            }
        }
    }
}



