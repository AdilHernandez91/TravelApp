//
//  RoundedTextField.swift
//  TravelApp
//
//  Created by German Hernandez on 03/04/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import Foundation
import UIKit

class RoundedTextField : UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
    }
    
}
