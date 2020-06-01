//
//  licenseCollectionViewCell.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 4/2/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class licenseCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var licenseNumberLabel: UILabel!
    @IBOutlet var ownerNAmeLabel: UILabel!
    @IBOutlet var managerNameLabel: UILabel!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var acc_codeLabel: UILabel!
    @IBOutlet var licenseNameLbel: UILabel!
    var licenseItem: SAIFZONELicense!
    var viewController: loginPageViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    @IBAction func downloadAction(_ sender: Any) {
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.viewController.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        
        
        if let fileUrl = URL(string: "\(AppConstants.WEB_SERVER_DOWNLOAD_LICENSE_FILE)\(licenseItem.license_no)") {
            
            print("the file to be downloaded is : \(fileUrl)")
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            print("docdir" + String(describing: documentsDirectory))
            let dataPath = documentsDirectory.appendingPathComponent("SAIFZONE docs")
            
            //let fileExists = FileManager().fileExists(atPath: dataPath.path)
            
            let destination = documentsDirectory.appendingPathComponent( "\(licenseItem.license_name).PDF")
            //Downloader1.load(url: fileUrl, to: destination) {
                
          //  }
            Downloader.load(filePath: destination, viewController: self.viewController, url: fileUrl) { (data) in
                
                DispatchQueue.main.async {
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    Utils.showAlertWith(title: "Success", message: "the file has been downloaded ,you can see it in files application", viewController: self.viewController)
                }
                
            }
        }
        
    }
}
