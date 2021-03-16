//
//  NotificationView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 7/23/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class NotificationView: UIView {
    
    @IBOutlet var tableView: UITableView!
    let activityData = ActivityData()
    var viewController: loginPageViewController!
    var notificationsArray: [SAIFZONENotification] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "notificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationTableViewCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func getNotifcation() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        
        
        WebService.getNotification { (json) in
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
            
            guard let data = json["Notifications"] as? [[String:Any]] else {return}
            
            
            for d in data {
                
                let rItem = SAIFZONENotification()
               
                rItem.ID = String(describing: d["ID"] ?? "" )
                rItem.CreateDate = String(describing: d["CreateDate"] ?? "" )
                rItem.NotificationTitle = String(describing: d["NotificationTitle"] ?? "" )
                rItem.NotificationText = String(describing: d["NotificationText"] ?? "" )
                rItem.IsRead = String(describing: d["IsRead"] ?? "" )
             
            
             
                
                self.notificationsArray.append(rItem)
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
extension NotificationView: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return notificationsArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationTableViewCell", for: indexPath) as! notificationTableViewCell
        
        let notiItem = notificationsArray[indexPath.section]
        cell.dateLabel.text = notiItem.CreateDate.components(separatedBy: "T")[0]
        cell.titleLabel.text = notiItem.NotificationTitle
        cell.descLabel.text = notiItem.NotificationText
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
