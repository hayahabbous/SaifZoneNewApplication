//
//  LicenseViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/18/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView


class LicenseViewController: UIViewController {
    
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var licenseTextField: SkyFloatingLabelTextField!
    let activityData = ActivityData()
    var licenseNo = ""
    
    var company: SAIFZONECompany?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 5
        nextButton.layer.masksToBounds = true
        
        
        
        
    }
    
    func checkFields() -> Bool{
        licenseNo = licenseTextField.text ?? ""
        
        if licenseNo.count == 0 || licenseNo == "" {
            Utils.showAlertWith(title: "Missing info", message: "Please enter License No ", viewController: self)
            return false
        }
        
        
        return true 
    }
    
    func CheckLicenseNo() {
        if checkFields() {
           
            DispatchQueue.main.async {
            
                guard Utilities().isInternetAvailable() == true else{
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    return
                }
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                
                //self.view.isUserInteractionEnabled = false
                
            }
               
            WebService.checkLicenseNo(license_no: licenseNo) { (json) in
                print(json)
                
                
                DispatchQueue.main.async {
                
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }
                
                guard let code = json["code"] as? Int else {return}
                guard let message = json["message"] as? String else {return}
                
                if code == 200 {
               
                    guard let data = json["data"] as? [String:Any] else {return}
                    guard let result = data["result"] as? [String:Any] else {return}
                    guard let list = result["list"] as? [[String:Any]] else {return}
                    
                    guard let firstObj = list.first as? [String:Any] else {return}
                    var _: SAIFZONECompany = SAIFZONECompany(dict: firstObj)
                    
                    self.company = SAIFZONECompany.getSAIFZONECompany()
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toOTP", sender: self)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        Utils.showAlertWith(title: "Error", message: message, viewController: self)
                    }
                }
                
                
                
            }
            
        }
    }
    @IBAction func nextButtonAction(_ sender: Any) {
        
        self.CheckLicenseNo()
    }
    
    
    
}
