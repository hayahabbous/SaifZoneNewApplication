//
//  profileView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 4/23/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class profileView: UIView {
    
    
    var viewController: loginPageViewController!

    @IBOutlet var userProfileView: UIView!
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var usernameArabicLabel: UILabel!
    @IBOutlet var faxLabel: UILabel!
    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var echannelMessageLabel: UILabel!
    @IBOutlet var applyLinkButton: UIButton!
    var userInfo: SAIFZONEUserInformation = SAIFZONEUserInformation()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        userProfileView.layer.cornerRadius = userProfileView.frame.height / 2
        
        userProfileView.layer.masksToBounds = true
        
        userProfileView.layer.borderColor = UIColor(red: 187/255, green: 156/255, blue: 98/255, alpha: 1.0).cgColor
        
        
        userProfileView.layer.borderWidth = 5
        
        echannelMessageLabel.isHidden = true
        applyLinkButton.isHidden = true
    }
    
    func loadUserInfo() {
        getUserInformation()
        getEchannellMessage()
    }
    func getUserInformation() {
        
        
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self.viewController)
            return
        }
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.viewController.activityData)
        
        WebService.getUserInformation { (json) in
            
            print(json)
            DispatchQueue.main.async {
                   
                    
            guard Utilities().isInternetAvailable() == true else{
            
                //Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                
                return
                
            }
                      
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
            
            guard let userList = json["userList"] as? [[String:Any]] else {return}
            guard let licenseDetails = json["licenseDetails"] as? [[String:Any]] else {return}
            
            
            for obj in userList {
                
                var item = SAIFZONEUserInformation()
                
                
                item.UserID = String(describing: obj["UserID"] ?? "")
                item.Login = String(describing: obj["Login"] ?? "")
                item.Password = String(describing: obj["Password"] ?? "")
                item.UserName = String(describing: obj["UserName"] ?? "")
                item.Email = String(describing: obj["Email"] ?? "")
                item.UserNameAr = String(describing: obj["UserNameAr"] ?? "")
                item.Phone = String(describing: obj["Phone"] ?? "")
                
                item.Mobile = String(describing: obj["Mobile"] ?? "")
                item.Fax = String(describing: obj["Fax"] ?? "")
                
                item.WebSite = String(describing: obj["WebSite"] ?? "")
                
                
                self.userInfo = item
                
                
                for o in licenseDetails {
                    item.companyCode = String(describing: o["ACC_CODE"] ?? "")
                }
                
                AppConstants.CompanyCode = item.companyCode
                
                UserDefaults.standard.set(item.companyCode, forKey: "companyCode")
                DispatchQueue.main.async {
                    self.usernameLabel.text = "Welcome , \(self.userInfo.UserName)"
                    self.usernameArabicLabel.text = "Username arabic : \(self.userInfo.UserNameAr)"
                    self.emailLabel.text = "Email : \(self.userInfo.Email)"
                    self.mobileLabel.text = "Mobile: \(self.userInfo.Mobile)"
                    self.faxLabel.text = "FAX : \(self.userInfo.Fax)"
                    self.websiteLabel.text = "Website : \(self.userInfo.WebSite)"
                    
                }

            }
        }
        
        
        
        
    }
    
    func getEchannellMessage() {
        
        
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self.viewController)
            return
        }
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.viewController.activityData)
        
        
        let stat = UserDefaults.standard.object(forKey: "companyCode") as? String  ?? ""
        WebService.getEchannelMessage(company_code: stat) { (json) in
            
            print(json)
            DispatchQueue.main.async {
                   
                    
            guard Utilities().isInternetAvailable() == true else{
            
                //Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                
                return
                
            }
                      
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
            
            guard let userList = json["Data"] as? [[String:Any]] else {return}
            
            if userList.count > 0 {
                DispatchQueue.main.async {
                    //self.echannelMessageLabel.isHidden = false
                    //self.applyLinkButton.isHidden = false
                }
            }
            
            
           
        }
        
        
        
    }
}
