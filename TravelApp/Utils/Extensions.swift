//
//  Extensions.swift
//  TravelApp
//
//  Created by German Hernandez on 01/04/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension String {
    
    var isNotEmpty: Bool {
        
        return !isEmpty
        
    }
    
}

extension UIViewController {
    
    func showDialog(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension Auth {
    
    func handleAuthError(error: Error, vc: UIViewController) {
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
        
    }
    
}
