//
//  TravelCell.swift
//  TravelApp
//
//  Created by German Hernandez on 06/04/2019.
//  Copyright © 2019 German Hernandez. All rights reserved.
//

import UIKit
import Kingfisher

class TravelCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var travelImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        travelImage.layer.cornerRadius = 10
    }

    func configureCell(travel: Travel) {
        titleLabel.text = travel.title
        
        if let url = URL(string: travel.picture) {
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            
            travelImage.kf.indicatorType = .activity
            travelImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }
    
}
