//
//  payInvoiceCell.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 5/3/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit

class payInvoiceCell: UICollectionViewCell {
    
    
    @IBOutlet var transactionDateLabel: UILabel!
    @IBOutlet var transactionNumberLabel: UILabel!
    @IBOutlet var transactionAmountLabel: UILabel!
    
    var viewController: loginPageViewController!
    var invoiceItem: SAIFZONEInvoice!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        
    }
}
