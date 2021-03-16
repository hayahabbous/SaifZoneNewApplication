//
//  visaCollectionViewCell.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 7/14/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit


class visaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
