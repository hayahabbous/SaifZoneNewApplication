//
//  SuggestedServiceTableViewCell.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/24/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit

class SuggestedServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    func set(service: SAIFZONEService, searchedTerm: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 21),
            .foregroundColor: UIColor(white: 0.56, alpha: 1.0)
        ]
        let attributedString = NSAttributedString(
            string: service.Caption.lowercased(),
            attributes: attributes
        )
        let mutableAttributedString = NSMutableAttributedString(
            attributedString: attributedString
        )
        mutableAttributedString.setBold(text: searchedTerm.lowercased())
        label.attributedText = mutableAttributedString
    }
}


