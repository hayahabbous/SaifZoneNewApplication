//
//  newLicenseView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 5/14/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SkyFloatingLabelTextField
class newLicenseView: UIView {
    
    
    var toolBar = UIToolbar()
    var licenseItems: [SAIFZONELicense] = []
    let activityData = ActivityData()
    @IBOutlet var selectLicenseTextField: SkyFloatingLabelTextField!
    var viewController: loginPageViewController!
    var selectedLicense: SAIFZONELicense!
    @IBOutlet var ownerNameLabel: UILabel!
    @IBOutlet weak var licensePickeView: UIPickerView!
    
    @IBOutlet var printLicenseButton: UIButton!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var managerNameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        licensePickeView.delegate = self
        
        
        selectLicenseTextField.inputView = licensePickeView
        printLicenseButton.layer.cornerRadius = 10
        printLicenseButton.layer.masksToBounds = true
        
        setupToolbar()
    }
    
    

    func setupToolbar() {
        toolBar.tintColor = AppConstants.purpleColor
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        toolBar.sizeToFit()
        
        
        var items = [UIBarButtonItem]()
        
        /*
        items.append(
            UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onClickedToolbeltButton(_:)))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace , target: self, action: nil))*/
        items.append(
            UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(onClickedToolbeltButton(_:)))
        )
        
        toolBar.items = items
        toolBar.backgroundColor = .lightGray
        
        selectLicenseTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func onClickedToolbeltButton(_ sender: Any){
        self.viewController.view.endEditing(true)
    }
    func loadLicense() {
        getLicenseDetails()
    }
    
    
    func getLicenseDetails() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        
        WebService.getLicense { (json) in
            print(json)
            
            
            DispatchQueue.main.async {
                       
                        
                guard Utilities().isInternetAvailable() == true else{
                
                    //Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    
                    return
                    
                }
                          
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
            }
            guard let errorCode = json["ErrorCode"] as? Int else {return}
            guard let message = json["Message"] as? String else {return}
            
            guard let data = json["Data"] as? [[String:Any]] else {return}
            self.licenseItems = []
            for d in data {
                var lItem = SAIFZONELicense()
                lItem.license_no = d["License No"] as? String ?? ""
                lItem.record_number = d["Record Number"] as? String ?? ""
                lItem.issue_date = d["Issue Date"] as? String ?? ""
                lItem.expirey_date = d["Expiry Date"] as? String ?? ""
                lItem.owner_name = d["Owner Name"] as? String ?? ""
                lItem.manager_name = d["Manager Name"] as? String ?? ""
                lItem.activity = d["Activity"] as? String ?? ""
                lItem.address = d["Address"] as? String ?? ""
                lItem.acc_code = d["ACC_CODE"] as? String ?? ""
                lItem.acc_name = d["ACC_NAME"] as? String ?? ""
                lItem.ar_manager = d["ar_manager"] as? String ?? ""
                lItem.license_name = d["license_name"] as? String ?? ""
                lItem.ar_pobox = d["ar_pobox"] as? String ?? ""
                lItem.company_name_ar_full = d["CompanyNameARFull"] as? String ?? ""
                lItem.license_status = d["LicStatus"] as? String ?? ""
             
                
                
                AppConstants.CompanyCode = lItem.acc_code
                self.licenseItems.append(lItem)
                
                
            }
            
            
            DispatchQueue.main.async {
                
                
                if self.licenseItems.count > 0 {
                    self.selectedLicense = self.licenseItems[0]
                    self.reloadLicenseView(item: self.licenseItems[0])
                }
            }
           
        }
    }
    
    func reloadLicenseView(item: SAIFZONELicense) {
        
        
        self.selectLicenseTextField.text = item.license_no
        self.ownerNameLabel.text = item.owner_name
        self.managerNameLabel.text = item.manager_name
        self.addressLabel.text = item.address
        self.activityLabel.text = item.activity
        
        
    }
    @IBAction func printLicenseAction(_ sender: Any) {
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.viewController.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        
        
        if let fileUrl = URL(string: "\(AppConstants.WEB_SERVER_DOWNLOAD_LICENSE_FILE)\(selectedLicense.license_no)") {
            
            print("the file to be downloaded is : \(fileUrl)")
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            print("docdir" + String(describing: documentsDirectory))
            let dataPath = documentsDirectory.appendingPathComponent("SAIFZONE docs")
            
            //let fileExists = FileManager().fileExists(atPath: dataPath.path)
            
            let destination = documentsDirectory.appendingPathComponent( "\(selectedLicense.license_no).PDF")
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
extension newLicenseView: UIPickerViewDelegate , UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return licenseItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = licenseItems[row]
        
        return item.license_no
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = licenseItems[row]
        
        self.selectedLicense = item
        reloadLicenseView(item: item)
    }
}
