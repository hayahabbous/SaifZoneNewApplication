//
//  statmentCollectionViewCell.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 4/27/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
class statmentCollectionViewCell: UICollectionViewCell {
    
    
    
    var viewController: statmentOfAccountViewController!
    @IBOutlet var transactionLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    
    @IBOutlet var downloadButton: UIButton!
    var statmentItem: SAIFZONEStatment?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
    }
    
    func showDownloadbutton() {
        
        guard let statmentItem = statmentItem else {return}
        if statmentItem.TransactionRef != "" {
            self.downloadButton.isHidden = false
        }else{
            self.downloadButton.isHidden = true
        }
        
    }
    
    
    @objc func getDownloadId() {
        
        
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self.viewController)
            return
        }
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.viewController.activityData)
        
        
        WebService.getDownloadStatmentId(recept_number: self.statmentItem?.TransactionRef ?? "") { (json) in
            
            print(json)
            
            
            DispatchQueue.main.async {
            
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
            guard let id = json["d"] as? String else {return}
            
            
            DispatchQueue.main.async {
                if let fileUrl = URL(string: "\(AppConstants.WEB_SERVER_DOWNLOAD_LINK_FILE_TEST)?FileID=\(id)&download=1") {
                    
                    print("the file to be downloaded is : \(fileUrl)")
                    
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    print("docdir" + String(describing: documentsDirectory))
                    let dataPath = documentsDirectory.appendingPathComponent("SAIFZONE docs")
                    
                    //let fileExists = FileManager().fileExists(atPath: dataPath.path)
                    
                    let destination = documentsDirectory.appendingPathComponent( "\(id).PDF")
                    //Downloader1.load(url: fileUrl, to: destination) {
                        
                  //  }
                    Downloader.load(filePath: destination, viewController: self.viewController, url: fileUrl) { (data) in
                        
                        DispatchQueue.main.async {
                            Utils.showAlertWith(title: "Success", message: "the file has been downloaded ,you can see it in files application", viewController: self.viewController)
                        }
                        
                    }
                }
            }
        }
    }
    @IBAction func downloadButtonAction(_ sender: Any) {
        
        getDownloadId()
    }
}
