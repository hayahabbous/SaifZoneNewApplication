//
//  requestsViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 4/2/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift
class requestsViewController: UIViewController {
    
    
    var submittedRequest:[SAIFZONERequest] = []
    var draftRequests:[SAIFZONEDraftRequest] = []
    let activityData = ActivityData()
    
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        
        
        setupCollectionView()
        
        getSubmittedRequests()
        getDraftRequests()
    }
    
    
    
    
    func getSubmittedRequests() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        
        
        WebService.getSubmittedRequest { (json) in
            
            
            DispatchQueue.main.async {
                 
                
                guard Utilities().isInternetAvailable() == true else{
                           
                               
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                               
                              
                    return
                               
                           
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                      
            }
            
            
            print(json)
            
            
            guard let errorCode = json["ErrorCode"] as? Int else {return}
            guard let message = json["Message"] as? String else {return}
            
            guard let data = json["Data"] as? [[String:Any]] else {return}
            
            
            self.submittedRequest = []
            for d in data {
                
                
                let rItem = SAIFZONERequest()
                rItem.create_date = d["CreateDate"] as? String ?? ""
                rItem.workflow_id = d["WorkflowID"] as? String ?? ""
                rItem.request_id = d["Requestid"] as? String ?? ""
                rItem.service_name = d["ServiceName"] as? String ?? ""
                rItem.created_dates = d["CreatedDates"] as? String ?? ""
                rItem.online_status_name = d["OnlineStatusName"] as? String ?? ""
                rItem.barcode = d["Barcode"] as? String ?? ""
                rItem.company_id = d["companyId"] as? String ?? ""
                
                rItem.last_remarks = d["LastRemarks"] as? String ?? ""
                rItem.object_id = d["ObjectID"] as? String ?? ""
                rItem.record_id = d["RecordID"] as? String ?? ""
                rItem.object_key = d["ObjectKey"] as? String ?? ""
                
                
                self.submittedRequest.append(rItem)
            }
            
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        
        
    }
    
    func getDraftRequests() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        WebService.getDraftRequest { (json) in
            print(json)
            
            DispatchQueue.main.async {
                                  
                                   
                          
                guard Utilities().isInternetAvailable() == true else{
                           
             
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    return
                    
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
            }
            
            
            print(json)
            
            guard let errorCode = json["ErrorCode"] as? Int else {return}
            guard let message = json["Message"] as? String else {return}
            
            guard let data = json["Data"] as? [[String:Any]] else {return}
            
            
            for d in data {
                
                let rItem = SAIFZONEDraftRequest()
                rItem.task_id = d["TaskID"] as? String ?? ""
                rItem.object_key = d["ObjectKey"] as? String ?? ""
                rItem.caption = d["Caption"] as? String ?? ""
                
                rItem.auid = d["AUID"] as? String ?? ""
                rItem.userid = d["UserID"] as? String ?? ""
                rItem.record_id = d["RecordID"] as? String ?? ""
                rItem.is_read = d["IsRead"] as? String ?? ""
                rItem.initiator = d["Initiator"] as? String ?? ""
                rItem.username = d["UserName"] as? String ?? ""
                rItem.previewlink = d["PreviewLink"] as? String ?? ""
                rItem.editlink = d["EditLink"] as? String ?? ""
                rItem.expr2 = d["Expr2"] as? String ?? ""
                rItem.next_action_time = d["NextActionTime"] as? String ?? ""
                rItem.object_id = d["ObjectID"] as? String ?? ""
                rItem.status = d["Status"] as? String ?? ""
                rItem.task_status = d["TaskStatus"] as? String ?? ""
                rItem.application_caption = d["ApplicationCaption"] as? String ?? ""
                rItem.app_description = d["AppDescription"] as? String ?? ""
                rItem.row_color = d["RowColor"] as? String ?? ""
                
                
                self.draftRequests.append(rItem)
                
            }
        }
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "requestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "requestCollectionViewCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.reloadData()
        collectionView.setNeedsLayout()
    }
    @IBAction func segmentAction(_ sender: Any) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            selectedIndex = 0
            
            
            
        }else{
           selectedIndex = 1
            
            
        }
        collectionView.reloadData()
    }
}
extension requestsViewController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    
    //MARK: - CollectionView
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if selectedIndex == 0 {
            return submittedRequest.count
        }
        return draftRequests.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "requestCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! requestCollectionViewCell
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "requestCollectionViewCell" {
            let cell = cell as! requestCollectionViewCell
            
            if selectedIndex == 0{
                
                let rItem = submittedRequest[indexPath.row]
                
                cell.serviceName.text = rItem.service_name
                cell.serviceStatus.text = rItem.online_status_name
                cell.serviceDate.text = rItem.create_date
                
                
                
            }else{
                let rItem = draftRequests[indexPath.row]
                
                
                cell.serviceName.text = rItem.application_caption
                cell.serviceStatus.text = rItem.caption
                cell.serviceDate.text = rItem.next_action_time
                
            }
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: self.collectionView.frame.width - 40, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 30.0
    }
    
    
}


extension requestsViewController :EmptyDataSetSource , EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Requests")
    }
}
