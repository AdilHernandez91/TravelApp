//
//  LoginViewController.swift
//  TravelApp
//
//  Created by German Hernandez on 29/03/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text , email.isNotEmpty ,
            let password = passwordTextField.text , password.isNotEmpty else {
                self.showDialog(title: "Validation error", message: "The email address and password are both required")
                return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                
                debugPrint(error)
                Auth.auth().handleAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                
            }
            else {
                
                self.activityIndicator.stopAnimating()
                // TODO: Redirect user to main storyboard
                
            }
            
        }
        
    }
    
}
