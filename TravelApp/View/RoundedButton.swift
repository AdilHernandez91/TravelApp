//
//  RoundedButton.swift
//  TravelApp
//
//  Created by German Hernandez on 01/04/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton : UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 7
        
    }
    
}
