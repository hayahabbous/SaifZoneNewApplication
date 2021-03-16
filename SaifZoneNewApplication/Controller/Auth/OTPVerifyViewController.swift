//
//  OTPVerifyViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/18/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView


class OTPVerifyViewController: UIViewController {
    
    let activityData = ActivityData()
    @IBOutlet var verificationCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var mobileNumber: UILabel!
    @IBOutlet var confirmedButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    
    
    
    var timer = 0
    var company: SAIFZONECompany?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        company = SAIFZONECompany.getSAIFZONECompany()
        nextButton.layer.cornerRadius = 5
        nextButton.layer.masksToBounds = true
        
        confirmedButton.layer.cornerRadius = 5
        confirmedButton.layer.masksToBounds = true
        
        companyNameLabel.text = company?.Company_Name
        mobileNumber.text = String(company?.sms_mobile_no.suffix(4) ?? "")
        
    
        
        
        confirmedButton.setTitle("Confirmed, send Verification Code", for: .normal)
    }
    
    
    func sendOTP() {
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        WebService.sendOTP(mobile_no: company?.sms_mobile_no ?? "") { (json) in
            DispatchQueue.main.async {
            
                guard Utilities().isInternetAvailable() == true else{
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    return
                }
                self.timer += 1
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
            guard let code = json["code"] as? Int else {return}
            guard let message = json["message"] as? String else {return}
            
            if code == 200 {
                
                guard let data = json["data"] as? [String:Any] else {return}
                guard let result = data["result"] as? [String:Any] else {return}
                guard let vcode = result["Code"] as? String else {
                    return
                }
                
                
                DispatchQueue.main.async {
                    AppConstants.verificationCode =  vcode
                    self.confirmedButton.setTitle("Verification Code has been sent ,resend again?", for: .normal)
                }
            }else{
                DispatchQueue.main.async {
                    Utils.showAlertWith(title: "Error", message: message, viewController: self)
                }
            }
        }
        
    }
    
    
    func checkIfOtpCorrect() {
    
        let vCode = verificationCodeTextField.text ?? ""
        
        if vCode == AppConstants.verificationCode {
            self.performSegue(withIdentifier: "toRegister", sender: self)
        }else {
            Utils.showAlertWith(title: "Error", message: "invalid code ", viewController: self)
        }
    }
    @IBAction func confirmedButtonAction(_ sender: Any) {
        
        if timer < 3 {
            self.sendOTP()
        }else {
            Utils.showAlertWith(title: "Error", message: "Please try to send code later", viewController: self)
        }
        
    }
    @IBAction func nextButtonAction(_ sender: Any) {
        checkIfOtpCorrect()
        
    }
}
