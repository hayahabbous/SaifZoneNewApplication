//
//  RegisterViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/18/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView



class RegisterViewController: UIViewController {
    
    
    @IBOutlet var finishButton: UIButton!
    @IBOutlet var confirmPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet var emailTextField: SkyFloatingLabelTextField!
    var company: SAIFZONECompany?
    
    var email: String?
    var password: String?
    var confirmedPassword: String?
    
    
    let activityData = ActivityData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        finishButton.layer.cornerRadius = 5
        finishButton.layer.masksToBounds = true
        
        
        company = SAIFZONECompany.getSAIFZONECompany()
    }
    
    
    func checkFields() -> Bool{

        
        
        email = emailTextField.text ?? ""
        password = passwordTextField.text ?? ""
        confirmedPassword = confirmPasswordTextField.text ?? ""
        
        
        
        if email?.count == 0 || email == "" {
            
            Utils.showAlertWith(title: "Missing info", message: "Please enter email ", viewController: self)
            return false
            
        }else if password?.count == 0 || password == "" {
            Utils.showAlertWith(title: "Missing info", message: "Please enter password ", viewController: self)
            
            return false
        }else if confirmedPassword?.count == 0 || confirmedPassword == "" {
            Utils.showAlertWith(title: "Missing info", message: "Please enter password confirmation", viewController: self)
            
            return false
        }else if confirmedPassword != password {
            Utils.showAlertWith(title: "Error", message: "Passwords mismatched ", viewController: self)
            
            return false
        }
        
        return true
    }
    func registerNewInvestor() {
        
        
        if checkFields() {
            DispatchQueue.main.async {
                      
                guard Utilities().isInternetAvailable() == true else{
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    return
                }
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                           
                //self.view.isUserInteractionEnabled = false
                
            }
            
            WebService.RegisterNewInvestor(email: email ?? "", password: password ?? "", caption: company?.Company_Name ?? "", tradeLicenseNo: company?.LICENSE_NO ?? "", MobileNo: company?.sms_mobile_no ?? "", MobileOTP: AppConstants.verificationCode, LinkedCompanyCode: company?.Company_ID ?? "", MobileNoEndsWith: String(company?.sms_mobile_no.suffix(4) ?? "")) { (json) in
                
                
                print(json)
                DispatchQueue.main.async {
                
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }
                
                guard let code = json["code"] as? Int else {return}
                guard let message = json["message"] as? String else {return}
                
                
                if code == 200 {
                
               
                    guard let data = json["data"] as? [String:Any] else {return}
                
                    DispatchQueue.main.async {
                        
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        Utils.showAlertWith(title: "Error", message: message, viewController: self)
                    }
                }
            }
            
        }
        
        
    }
    @IBAction func finishButtonAction(_ sender: Any) {
        
        registerNewInvestor()
    }
}
