//
//  RegisterViewController.swift
//  TravelApp
//
//  Created by German Hernandez on 29/03/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text , email.isNotEmpty ,
            let password = passwordTextField.text , password.isNotEmpty else {
                showDialog(title: "Validation error", message: "The email address and password are both required")
                return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                
                debugPrint(error)
                Auth.auth().handleAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                
            }
            else {
                
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }
        
    }
    
}
