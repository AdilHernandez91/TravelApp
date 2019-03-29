//
//  ViewController.swift
//  TravelApp
//
//  Created by German Hernandez on 29/03/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "authViewController")
        
        present(controller, animated: true, completion: nil)
        
    }

}

