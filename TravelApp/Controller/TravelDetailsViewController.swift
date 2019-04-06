//
//  TravelDetailsViewController.swift
//  TravelApp
//
//  Created by German Hernandez on 06/04/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import UIKit
import Kingfisher

class TravelDetailsViewController: UIViewController {
    
    @IBOutlet weak var travelImage: UIImageView!
    @IBOutlet weak var travelTitle: UILabel!
    @IBOutlet weak var travelDescription: UILabel!
    
    var selectedTravel : Travel!

    override func viewDidLoad() {
        super.viewDidLoad()

        travelTitle.text = selectedTravel.title
        travelDescription.text = selectedTravel.description
        
        navigationItem.title = travelTitle.text
        
        configureImage()
    }
    
    func configureImage() {
        if let url = URL(string: selectedTravel.picture) {
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            
            travelImage.kf.indicatorType = .activity
            travelImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }
}
