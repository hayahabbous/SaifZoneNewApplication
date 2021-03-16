//
//  auditReportView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 6/20/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import EmptyDataSet_Swift
import NVActivityIndicatorView


class auditReportView: UIView {
    
    var viewController: loginPageViewController!
    
    var auditArray: [SAIFZONEAudit] = []
   
    let activityData = ActivityData()
    @IBOutlet var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "auditTableviewCell", bundle: nil), forCellReuseIdentifier: "auditTableviewCell")
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        //getDraftRequests()
    }
    
    
    func getDraftRequests() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        
        let stat = UserDefaults.standard.object(forKey: "companyCode") as? String  ?? ""
        WebService.getAuditReport(company_code: stat) { (json) in
            print(json)
            
            DispatchQueue.main.async {
                                  
                                   
                          
                guard Utilities().isInternetAvailable() == true else{
                           
             
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self.viewController)
                    return
                    
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
            }
            
            
            print(json)
            
            guard let errorCode = json["ErrorCode"] as? Int else {return}
            guard let message = json["Message"] as? String else {return}
            
            guard let data = json["Data"] as? [[String:Any]] else {return}
            
            self.auditArray = []
            for d in data {
                
                let rItem = SAIFZONEAudit()
               
                rItem.ARID = String(describing: d["ARID"] ?? "" )
                rItem.Caption = String(describing: d["Caption"] ?? "" )
                rItem.CompanyCode = String(describing: d["CompanyCode"] ?? "" )
                rItem.CompanyName = String(describing: d["CompanyName"] ?? "" )
                rItem.FiscalYearEnding = String(describing: d["FiscalYearEnding"] ?? "" )
                rItem.Email = String(describing: d["Email"] ?? "" )
                rItem.Mobile = String(describing: d["Mobile"] ?? "" )
                rItem.Memorandum = String(describing: d["Memorandum"] ?? "" )
                rItem.Addendum = String(describing: d["Addendum"] ?? "" )
                rItem.Auditor = String(describing: d["Auditor"] ?? "" )
                rItem.AuditReport = String(describing: d["AuditReport"] ?? "" )
                rItem.SampleLink = String(describing: d["SampleLink"] ?? "" )
                rItem.UndertakingWithin = String(describing: d["UndertakingWithin"] ?? "" )
                rItem.SubmitionDate = String(describing: d["SubmitionDate"] ?? "" )
                rItem.PreviousYearReport = String(describing: d["PreviousYearReport"] ?? "" )
                rItem.Confirmation = String(describing: d["Confirmation"] ?? "" )
                rItem.MemorandumPath = String(describing: d["MemorandumPath"] ?? "" )
                
                
                
                rItem.AddendumPath = String(describing: d["AddendumPath"] ?? "" )
                rItem.AuditReportPath = String(describing: d["AuditReportPath"] ?? "" )
                
             
                
                self.auditArray.append(rItem)
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
extension auditReportView: UITableViewDelegate , UITableViewDataSource , EmptyDataSetDelegate , EmptyDataSetSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if auditArray.count > 0 {
            return auditArray.count 
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "auditTableviewCell", for: indexPath) as! auditTableviewCell
        
        
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "auditTableviewCell" {
            let cell = cell as! auditTableviewCell
            let item = auditArray[indexPath.section]
            
            //cell.selectStatment = item
            //cell.statmentViewController = self
            let isoDate = "2016-04-14T10:44:00"

            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "dd/MM/yyyy' 'HH:mm:ss"
            let date = dateFormatter.date(from:item.SubmitionDate)
            if date != nil {
                cell.dateLabel.text = date?.stringFromFormat("dd/MM/yyyy")
            }else{
                cell.dateLabel.text = item.SubmitionDate == "<null>" ? "N/A" : item.SubmitionDate.components(separatedBy: " ")[0]
            }
            
            cell.underTakingWithLabel.text = item.UndertakingWithin == "<null>" ? "N/A" : item.UndertakingWithin
            cell.companyName.text = item.CompanyName == "<null>" ? "N/A" : item.CompanyName
            cell.emailLabel.text = item.Email == "<null>" ? "N/A" : item.Email
            cell.fiscalYearEndingLabel.text = item.FiscalYearEnding == "<null>" ? "N/A" : item.FiscalYearEnding
            cell.mobileLabel.text = item.Mobile == "<null>" ? "N/A" : item.Mobile
            
            
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            
            
        }
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Reports")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
}
 
