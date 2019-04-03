//
//  ViewController.swift
//  TravelApp
//
//  Created by German Hernandez on 29/03/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            
            presentAuthController()
            
        }
    }
    
    fileprivate func presentAuthController() {
        
        let storyboard = UIStoryboard(name: Storyboard.AuthStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.AuthViewController)
        
        present(controller, animated: true, completion: nil)
        
    }

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            
            try Auth.auth().signOut()
            presentAuthController()
            
        } catch {
            
            debugPrint(error)
            Auth.auth().handleAuthError(error: error, vc: self)
            
        }
        
    }
    
}

