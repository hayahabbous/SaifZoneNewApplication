//
//  reqDocumentCell.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 5/2/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit



class reqDocumentCell: UICollectionViewCell {
    
    @IBOutlet var servicNameLabel: UILabel!
    @IBOutlet var cardLabel: UILabel!
    @IBOutlet var serviceDescriptionLabel: UILabel!
    @IBOutlet var uploadButton: UIButton!
    
    var viewController: loginPageViewController!
    var docItem: SAIFZONEDocuments!
   
    var changedelegate: changeViewProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds  = true
    }
    @IBAction func uploadAction(_ sender: Any) {
        
        //changedelegate.openWebView(fielURL: docItem.fileURL)
    }
}
