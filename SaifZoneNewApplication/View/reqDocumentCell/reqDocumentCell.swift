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
    
    var viewController: requestsViewController!
    var docItem: SAIFZONEDocuments!
   
    var changedelegate: changeViewProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds  = true
    }
    @IBAction func uploadAction(_ sender: Any) {
        
        
        if AppConstants.LIVE {
            viewController.selectedServiceURL = "https://bmportal.saif-zone.com/AppRecordMP.aspx?bo=1055&EditMode=New&Hidenavigation=1&hidelist=1&HideDelete=1&returnpage=default&dvdocumentid=\(self.docItem.RequestAttachmentID)"
        }else{
            viewController.selectedServiceURL = "https://devdpm.saif-zone.com/AppRecordMP.aspx?bo=1055&EditMode=New&Hidenavigation=1&hidelist=1&HideDelete=1&returnpage=default&dvdocumentid=\(self.docItem.RequestAttachmentID)"
        }
        
        
        
        viewController.performSegue(withIdentifier: "toWebView", sender: self)
        //changedelegate.openWebView(fielURL: docItem.fileURL)
    }
}
