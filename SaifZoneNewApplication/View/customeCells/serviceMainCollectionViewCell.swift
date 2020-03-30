//
//  serviceMainCollectionViewCell.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/9/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit



class serviceMainCollectionViewCell: UICollectionViewCell {
    @IBOutlet var serviceCaptionLabel: UILabel!
    @IBOutlet var serviceImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
    }
}
