//
//  visaView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 7/14/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class visaView: UIView {
    
    var visaItem: SAIFZONEVisa = SAIFZONEVisa()
    let activityData = ActivityData()
    var viewController: loginPageViewController!
    var approvedVisaCollectionView: UICollectionView!
    var employmentVisaCollectionView: UICollectionView!
    var residenceVisaCollectionView: UICollectionView!
    var cancelationVisaCollectionView: UICollectionView!
    var abscondersVisaCollectionView: UICollectionView!
    //var approvedVisaCollectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "visaTableViewCell", bundle: nil), forCellReuseIdentifier: "visaTableViewCell")
        
        tableView.tableFooterView = UIView()
    }
    
    
    func getVisa() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        
        
        WebService.getVisaInformation { (json) in
            print(json)
            
            DispatchQueue.main.async {
                                  
                                   
                          
                guard Utilities().isInternetAvailable() == true else{
                           
             
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self.viewController)
                    return
                    
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
            }
            
            
            print(json)
            
            //guard let errorCode = json["ErrorCode"] as? Int else {return}
            //guard let message = json["Message"] as? String else {return}
            
            guard let data = json["visaDetails"] as? [[String:Any]] else {return}
            
            
            for d in data {
                
                let rItem = SAIFZONEVisa()
               
                rItem.approved_visa = String(describing: d["approved_visa"] ?? "" )
                rItem.utilized_visa = String(describing: d["utilized_visa"] ?? "" )
                rItem.balance_visa_available = String(describing: d["balance_visa_available"] ?? "" )
                rItem.immig_card_no = String(describing: d["immig_card_no"] ?? "" )
                rItem.Immig_issue_dt = String(describing: d["Immig_issue_dt"] ?? "" )
                rItem.Immig_expiry_dt = String(describing: d["Immig_expiry_dt"] ?? "" )
                rItem.immig_card_status = String(describing: d["immig_card_status"] ?? "" )
                rItem.applied_emp_visa = String(describing: d["applied_emp_visa"] ?? "" )
                rItem.expired_emp_visa = String(describing: d["expired_emp_visa"] ?? "" )
                rItem.stamped_res_visa = String(describing: d["stamped_res_visa"] ?? "" )
                rItem.rv_to_be_stamped = String(describing: d["rv_to_be_stamped"] ?? "" )
                rItem.rv_expiring_30_days = String(describing: d["rv_expiring_30_days"] ?? "" )
                rItem.pending_app = String(describing: d["pending_app"] ?? "" )
                rItem.rejected_app = String(describing: d["rejected_app"] ?? "" )
                rItem.cancellation_no_leave_dt = String(describing: d["cancellation_no_leave_dt"] ?? "" )
                rItem.out_country_cancellation = String(describing: d["out_country_cancellation"] ?? "" )
                rItem.total_cancellation = String(describing: d["total_cancellation"] ?? "" )
                
                
                
                rItem.transfer_in = String(describing: d["transfer_in"] ?? "" )
                rItem.transfer_out = String(describing: d["transfer_out"] ?? "" )
                
                rItem.internal_transfer_in = String(describing: d["internal_transfer_in"] ?? "" )
                
                rItem.internal_transfer_out = String(describing: d["internal_transfer_out"] ?? "" )
                
                rItem.non_sponsored = String(describing: d["non_sponsored"] ?? "" )
                
                rItem.pass_in = String(describing: d["pass_in"] ?? "" )
                
                rItem.pass_out = String(describing: d["pass_out"] ?? "" )
                
                rItem.pass_delay = String(describing: d["pass_delay"] ?? "" )
                
                rItem.pass_exempted = String(describing: d["pass_exempted"] ?? "" )
                
                rItem.pass_out_w_deposit = String(describing: d["pass_out_w_deposit"] ?? "" )
                
                rItem.pass_expiry_60_days = String(describing: d["pass_expiry_60_days"] ?? "" )
                
                rItem.acc_code = String(describing: d["acc_code"] ?? "" )
                
                rItem.acc_name = String(describing: d["acc_name"] ?? "" )
                rItem.total_absconders = String(describing: d["total_absconders"] ?? "" )
                
                rItem.absconders_per = String(describing: d["absconders_per"] ?? "" )
                
                rItem.Company_ref_no = String(describing: d["Company_ref_no"] ?? "" )
                
                rItem.COUNTRY_NAME = String(describing: d["COUNTRY_NAME"] ?? "" )
                
             
                
                self.visaItem = rItem
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
extension visaView: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visaTableViewCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "visaTableViewCell" {
            
            let cell = cell as! visaTableViewCell
            switch indexPath.section {
            case 0:
                self.approvedVisaCollectionView = cell.collectionView
                
                approvedVisaCollectionView.delegate = self
                approvedVisaCollectionView.dataSource = self
                
                approvedVisaCollectionView.showsVerticalScrollIndicator = false
                
                approvedVisaCollectionView.register(UINib(nibName: "visaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "visaCollectionViewCell")
                if let layout = approvedVisaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical  // .horizontal
                }
                approvedVisaCollectionView.isPagingEnabled = true
                approvedVisaCollectionView.reloadData()
                approvedVisaCollectionView.setNeedsLayout()
                
                
                
            case 1:
                self.employmentVisaCollectionView = cell.collectionView
                
                employmentVisaCollectionView.delegate = self
                employmentVisaCollectionView.dataSource = self
                
                employmentVisaCollectionView.showsVerticalScrollIndicator = false
                
                employmentVisaCollectionView.register(UINib(nibName: "visaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "visaCollectionViewCell")
                if let layout = employmentVisaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical  // .horizontal
                }
                employmentVisaCollectionView.isPagingEnabled = true
                employmentVisaCollectionView.reloadData()
                employmentVisaCollectionView.setNeedsLayout()
                
            case 2:
                self.residenceVisaCollectionView = cell.collectionView
                
                residenceVisaCollectionView.delegate = self
                residenceVisaCollectionView.dataSource = self
                
                residenceVisaCollectionView.showsVerticalScrollIndicator = false
                
                residenceVisaCollectionView.register(UINib(nibName: "visaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "visaCollectionViewCell")
                if let layout = residenceVisaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical  // .horizontal
                }
                residenceVisaCollectionView.isPagingEnabled = true
                residenceVisaCollectionView.reloadData()
                residenceVisaCollectionView.setNeedsLayout()
                
                
            case 3:
                self.cancelationVisaCollectionView = cell.collectionView
                
                cancelationVisaCollectionView.delegate = self
                cancelationVisaCollectionView.dataSource = self
                
                cancelationVisaCollectionView.showsVerticalScrollIndicator = false
                
                cancelationVisaCollectionView.register(UINib(nibName: "visaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "visaCollectionViewCell")
                if let layout = cancelationVisaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical  // .horizontal
                }
                cancelationVisaCollectionView.isPagingEnabled = true
                cancelationVisaCollectionView.reloadData()
                cancelationVisaCollectionView.setNeedsLayout()
                
                
                
            case 4:
                self.abscondersVisaCollectionView = cell.collectionView
                
                abscondersVisaCollectionView.delegate = self
                abscondersVisaCollectionView.dataSource = self
                
                abscondersVisaCollectionView.showsVerticalScrollIndicator = false
                
                abscondersVisaCollectionView.register(UINib(nibName: "visaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "visaCollectionViewCell")
                if let layout = abscondersVisaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .vertical  // .horizontal
                }
                abscondersVisaCollectionView.isPagingEnabled = true
                abscondersVisaCollectionView.reloadData()
                abscondersVisaCollectionView.setNeedsLayout()
            default:
                print("")
            }
            
            
            
            
            
            
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let sectionLabel = UILabel(frame: CGRect(x: 8, y: 0, width:
        tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        sectionLabel.textColor = UIColor(red: 205/256, green: 175/256, blue: 116/256, alpha: 1.0)
        //sectionLabel.text = "NETWORK SETTINGS"
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 17)
        switch section {
        case 0:
            sectionLabel.text =  "Approved Visa"
            
        case 1:
            sectionLabel.text  = "Employment Visa"
            
        case 2:
            sectionLabel.text =  "Residences Visa"
            
        case 3:
            sectionLabel.text =  "Cancelation Visa"
            
        case 4:
            sectionLabel.text =  "Absconders"
        default:
            sectionLabel.text =  ""
        }
        
        
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Approved Visa"
            
        case 1:
            return "Employment Visa"
            
        case 2:
            return "Residences Visa"
            
        case 3:
            return "Cancelation Visa"
            
        case 4:
            return "Absconders"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
extension visaView: UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == approvedVisaCollectionView {
            return 3
        }else if collectionView == employmentVisaCollectionView{
            return 2
        }else if collectionView == residenceVisaCollectionView{
            return 3
        }else if collectionView == cancelationVisaCollectionView{
            return 2
        }else if collectionView == abscondersVisaCollectionView{
            return 2
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visaCollectionViewCell", for: indexPath) as! visaCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = cell as! visaCollectionViewCell
        if collectionView == approvedVisaCollectionView {
        
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Approved Visa"
                cell.numberLabel.text = self.visaItem.approved_visa
                
            case 1:
                cell.titleLabel.text = "Utilized Visa"
                cell.numberLabel.text = self.visaItem.utilized_visa
                
            case 2:
                cell.titleLabel.text = "Balance"
                cell.numberLabel.text = self.visaItem.balance_visa_available
            default:
                print("")
            }
        }else if collectionView == employmentVisaCollectionView{
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Applied Visa"
                cell.numberLabel.text = self.visaItem.applied_emp_visa
                
            case 1:
                cell.titleLabel.text = "Expired Visa"
                cell.numberLabel.text = self.visaItem.expired_emp_visa
                
            case 2:
                cell.titleLabel.text = "Balance"
            default:
                print("")
            }
        }else if collectionView == residenceVisaCollectionView{
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Stamped Visa"
                cell.numberLabel.text = self.visaItem.stamped_res_visa
                
            case 1:
                cell.titleLabel.text = "To be stamped Visa"
                cell.numberLabel.text = self.visaItem.rv_to_be_stamped
                
            case 2:
                cell.titleLabel.text = "Expiry within 30 Days"
                cell.numberLabel.text = self.visaItem.rv_expiring_30_days
            default:
                print("")
            }
        }else if collectionView == cancelationVisaCollectionView{
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Cancel No leaving Date"
                cell.numberLabel.text = self.visaItem.cancellation_no_leave_dt
                
            case 1:
                cell.titleLabel.text = "Cancel Without Passport"
                cell.numberLabel.text = self.visaItem.out_country_cancellation
                
            case 2:
                cell.titleLabel.text = "Balance"
            default:
                print("")
            }
        }else if collectionView == abscondersVisaCollectionView{
            
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Total Absconders"
                cell.numberLabel.text = self.visaItem.total_absconders
                
            case 1:
                cell.titleLabel.text = "Absconder"
                cell.numberLabel.text = self.visaItem.absconders_per
                
            case 2:
                cell.titleLabel.text = "Balance"
            default:
                print("")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3) - 14  , height: (collectionView.frame.width / 3) + 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}
