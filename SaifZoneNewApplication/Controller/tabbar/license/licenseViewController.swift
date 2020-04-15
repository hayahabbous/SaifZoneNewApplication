//
//  licenseViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 4/2/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


class licenseViewController: UIViewController {
    
    
    var backButton: UIBarButtonItem!
    var licenseItem: SAIFZONELicense = SAIFZONELicense()
    let activityData = ActivityData()
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backAction))
        backButton.tintColor = .white
        self.navigationItem.rightBarButtonItems = [backButton]
        setupCollectionView()
        
        getLicenseDetails()
    }
    
    @objc func backAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
                
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    
                    return
                    
                }
                          
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
            }
            guard let errorCode = json["ErrorCode"] as? Int else {return}
            guard let message = json["Message"] as? String else {return}
            
            guard let data = json["Data"] as? [[String:Any]] else {return}
            
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
             
                
                
                
                DispatchQueue.main.async {
                    
                    self.licenseItem = lItem
                    self.collectionView.reloadData()
                }
       

                
                
                
            }
            
            
            
            
        }
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "licenseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "licenseCollectionViewCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.reloadData()
        collectionView.setNeedsLayout()
    }
}
extension licenseViewController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //MARK: - CollectionView
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       
        return 1
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "licenseCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! licenseCollectionViewCell
        
        
        
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "licenseCollectionViewCell" {
            let cell = cell as! licenseCollectionViewCell
            
            
            
            cell.managerNameLabel.text = licenseItem.manager_name
            cell.licenseNumberLabel.text = licenseItem.license_no
            cell.ownerNAmeLabel.text = licenseItem.owner_name
            cell.licenseNameLbel.text = licenseItem.license_name
            cell.activityLabel.text = licenseItem.activity
            cell.addressLabel.text = licenseItem.address
            cell.acc_codeLabel.text = licenseItem.acc_code
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: self.collectionView.frame.width - 40, height: self.collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 30.0
    }
    
    
}



