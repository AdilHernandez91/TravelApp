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
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text , email.isNotEmpty ,
            let username = usernameTextField.text , username.isNotEmpty ,
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
                
                guard let firUser = result?.user else { return }
                
                let user = User.init(id: firUser.uid, email: email, username: username)
                
                self.createFirestoreUser(user: user)
                
            }
            
        }
        
    }
    
    func createFirestoreUser(user: User) {
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        
        let data = User.modelToData(user: user)
        
        newUserRef.setData(data) { (error) in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleAuthError(error: error, vc: self)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
    
}
