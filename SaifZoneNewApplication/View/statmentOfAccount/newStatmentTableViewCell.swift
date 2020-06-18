//
//  newStatmentTableViewCell.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 5/12/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class newStatmentTableViewCell: UITableViewCell {
    
    
    var selectStatment: SAIFZONEStatment!
    var statmentViewController: newStatmentOfAccountViewController!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var statmentCaption: UILabel!
    @IBOutlet var statmentDescriptionLabel: UILabel!
    @IBOutlet var debitLabel: UILabel!
    @IBOutlet var creditLabel: UILabel!
    @IBOutlet var pdcLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        
        if selectStatment.TransactionRef != "<null>" {
           //download statment
            
            
            let logOutAlertActionController = UIAlertController(title:"", message: NSLocalizedString("do you want to downlaod this file ?", comment:""), preferredStyle: .alert )
                   
                   
            let yesAlerActionOption = UIAlertAction(title:NSLocalizedString("Yes",comment:""), style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
                  
                self.getDownloadId()
                
            })
            
            let noAlertActionOption = UIAlertAction(title:NSLocalizedString("No",comment:""), style: .default, handler: nil)
            
            logOutAlertActionController.addAction(yesAlerActionOption)
            logOutAlertActionController.addAction(noAlertActionOption)
            
            self.statmentViewController.present(logOutAlertActionController, animated: true, completion: nil)
            
        }else{
            
        }
    }
    @objc func getDownloadId() {
        
        
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: statmentViewController)
            return
        }
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.statmentViewController.activityData)
        
        
        WebService.getDownloadStatmentId(recept_number: self.selectStatment.TransactionRef ?? "") { (json) in
            
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
                    Downloader.load(filePath: destination, viewController: self.statmentViewController, url: fileUrl) { (data) in
                        
                        DispatchQueue.main.async {
                            Utils.showAlertWith(title: "Success", message: "the file has been downloaded ,you can see it in files application", viewController: self.statmentViewController)
                        }
                        
                    }
                }
            }
        }
    }

}
