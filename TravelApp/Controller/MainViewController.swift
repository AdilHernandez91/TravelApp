//
//  ViewController.swift
//  TravelApp
//
//  Created by German Hernandez on 29/03/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            
            presentAuthController()
            
        }
        
    }
    
    fileprivate func presentAuthController() {
        
        let storyboard = UIStoryboard(name: Storyboard.AuthStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.AuthViewController)
        
        present(controller, animated: true, completion: nil)
        
    }

}

