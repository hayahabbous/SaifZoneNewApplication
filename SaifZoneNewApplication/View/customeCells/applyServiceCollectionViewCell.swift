//
//  applyServiceCollectionViewCell.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/19/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit



class applyServiceCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var applyButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        applyButton.layer.cornerRadius = 5
        applyButton.layer.masksToBounds = true
        
    }
}
