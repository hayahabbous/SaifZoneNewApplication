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
    
    
    var eChannelArray: [[String:Any]] = [[:]]
    var paymentsArray: [SAIFZONEPaymentRequest] = []
    var submittedRequest:[SAIFZONERequest] = []
    var draftRequests:[SAIFZONEDraftRequest] = []
    let activityData = ActivityData()
    var documentsArray: [SAIFZONEDocuments] = []
    var selectedServiceURL: String = ""
    var selectedService: SAIFZONEDraftRequest = SAIFZONEDraftRequest()
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    
    var webUrlString: String = ""
    
    var paymentCollectionView: UICollectionView!
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        
        
        setupCollectionView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        getSubmittedRequests()
        getDraftRequests()
        //getRequieredDocuments()
        getRequiredFields()
    }
    
    func getRequieredDocuments() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        WebService.getRequieredDocuments { (json) in
            
            print(json)
            
            DispatchQueue.main.async {
                       
                        
                guard Utilities().isInternetAvailable() == true else{
                
                    //Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    
                    return
                    
                }
                          
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                
                guard let message  = json["Message"] as? String else {return}
                guard let errorCode  = json["ErrorCode"] as? Int else {return}
                guard let data  = json["Data"] as? [[String:Any]] else {return}
                
                self.documentsArray = []
                for obj in data {
                    let item = SAIFZONEDocuments()
                    item.RequestAttachmentID = obj["RequestAttachmentID"] as? String ?? ""
                    item.AttachmentTypeID = obj["AttachmentTypeID"] as? String ?? ""
                    item.AttachmentTypeDescription = obj["AttachmentTypeDescription"] as? String ?? ""
                    item.AttachmentName = obj["AttachmentName"] as? String ?? ""
                    item.RequestID = obj["RequestID"] as? String ?? ""
                    item.WebsiteRequestId = obj["WebsiteRequestId"] as? String ?? ""
                    item.CompanyId = obj["CompanyId"] as? String ?? ""
                    item.ServiceName = obj["ServiceName"] as? String ?? ""
                    item.IsUploaded = obj["IsUploaded"] as? String ?? ""
             
                    
                    item.fileURL = "https://devdp.saif-zone.com/AppRecordMP.aspx?bo=1055&EditMode=New&Hidenavigation=1&hidelist=1&HideDelete=1&returnpage=default&dvdocumentid=\(item.RequestAttachmentID)"
                    self.documentsArray.append(item)
                    
                    
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
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
            
            self.draftRequests = []
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
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func getRequiredFields() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        let stat = UserDefaults.standard.object(forKey: "companyCode") as? String  ?? ""
        WebService.getRequiredFields(company_code: stat) { (json) in
            
            print(json)
            
            DispatchQueue.main.async {
                       
                        
                guard Utilities().isInternetAvailable() == true else{
                
                    //Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    
                    return
                    
                }
                          
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
              
                //guard let message  = json["Message"] as? String else {return}
                //guard let errorCode  = json["ErrorCode"] as? Int else {return}
                guard let data  = json["requiredDocumentsList"] as? [[String:Any]] else {return}
                
                
                guard let payments  = json["Payments"] as? [[String:Any]] else {return}
                guard let eChannelList  = json["eChannelList"] as? [[String:Any]] else {return}
                
                self.documentsArray = []
                self.paymentsArray = []
                self.eChannelArray = eChannelList
                //self.eChannelArray.append(["new":"new"])
                for obj in data {
                    let item = SAIFZONEDocuments()
                    item.RequestAttachmentID = obj["RequestAttachmentID"] as? String ?? ""
                    item.AttachmentTypeID = obj["AttachmentTypeID"] as? String ?? ""
                    item.AttachmentTypeDescription = obj["AttachmentTypeDescription"] as? String ?? ""
                    item.AttachmentName = obj["AttachmentName"] as? String ?? ""
                    item.RequestID = obj["RequestID"] as? String ?? ""
                    item.WebsiteRequestId = obj["WebsiteRequestId"] as? String ?? ""
                    item.CompanyId = obj["CompanyId"] as? String ?? ""
                    item.ServiceName = obj["ServiceName"] as? String ?? ""
                    item.IsUploaded = obj["IsUploaded"] as? String ?? ""
             
                    
                    item.fileURL = "https://devdp.saif-zone.com/AppRecordMP.aspx?bo=1055&EditMode=New&Hidenavigation=1&hidelist=1&HideDelete=1&returnpage=default&dvdocumentid=\(item.RequestAttachmentID)"
                    self.documentsArray.append(item)
                    
                    
                    
                }
                
                
                for d in payments {
                        
                        
                    let rItem = SAIFZONEPaymentRequest()
                       
                    
                    rItem.ID = String(describing: d["RequestID"] ?? "" )
                    
                    rItem.PaymentCaption = String(describing: d["Caption"] ?? "" )
                    
                    rItem.AmountValue = String(describing: d["TotalAmount"] ?? "" )
                    
                    rItem.Status = String(describing: d["Status"] ?? "" )
                
                    self.paymentsArray.append(rItem)
                        
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "requestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "requestCollectionViewCell")
        
        
        collectionView.register(UINib(nibName: "reqDocumentCell", bundle: nil), forCellWithReuseIdentifier: "reqDocumentCell")
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        //collectionView.isPagingEnabled = true
        collectionView.reloadData()
        collectionView.setNeedsLayout()
    }
    @IBAction func segmentAction(_ sender: Any) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            selectedIndex = 0
            
            
            
        }else if segmentControl.selectedSegmentIndex == 1{
           selectedIndex = 1
            
            
        }else {
           selectedIndex = 2
            
            
        }
        collectionView.reloadData()
    }
    
    @objc func pressApplyButton(sender: UIButton) {
        guard let cell = sender.superview?.superview as? UICollectionViewCell else {
            return // or fatalError() or whatever
        }

        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        
        var paymentItem: SAIFZONEPaymentRequest!
        if eChannelArray.count > 0 {
            paymentItem = paymentsArray[indexPath.row - 1]
        }else{
            paymentItem = paymentsArray[indexPath.row ]
        }
         
        
        self.webUrlString = "/default.aspx?PageId=31&tID=\(paymentItem.ID)"
        
        
        self.performSegue(withIdentifier: "toWeb2", sender: self)
        
    }
    
    @objc func echannelButton(_ sender: Any) {
          
    
              
          selectedServiceURL = "\(AppConstants.WEB_BASIC_URL_TEST_BASE_URL)/AppRecordMP.aspx?bo=1123&EditMode=New&HideNavigation=1&hidelist=1"
          
          
          
          self.performSegue(withIdentifier: "toWebView", sender: self)
      }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView"  {
            
            
            let dest = segue.destination as! webViewController
            if selectedIndex == 1 {
                dest.selectedServiceURL = self.selectedServiceURL
                //dest.mainServicesArray = self.mainServicesArray
                //dest.delegate = self
                
                
                let backItem = UIBarButtonItem()
                backItem.title = selectedService.application_caption
                navigationItem.backBarButtonItem = backItem
                navigationItem.backBarButtonItem?.tintColor = AppConstants.purpleColor
            }else{
                dest.selectedServiceURL = self.selectedServiceURL
            }
            
        }else if segue.identifier == "toWeb2"  {
            let dest = segue.destination as! newWebPageViewController
            dest.webUrlString = self.webUrlString
           
        }
    }
}
extension requestsViewController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    
    //MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if selectedIndex == 0{
            
            if collectionView == paymentCollectionView {
                return 1
            }
            return 3
        }
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if selectedIndex == 2 {
            return submittedRequest.count
        }else if selectedIndex == 1 {
            return draftRequests.count
        }
        
        if collectionView == paymentCollectionView  {
            return eChannelArray.count
        }
        if section == 0 {
            if eChannelArray.count > 0 {
                return eChannelArray.count + 1
            }
            return 0
        }else if section == 1 {
            if paymentsArray.count > 0 {
                return paymentsArray.count + 1
            }
            return 0
        }else if section == 2 {
            
            if documentsArray.count > 0 {
                return documentsArray.count + 1
            }
            return 0
        }
      
        
        
        if eChannelArray.count > 0 {
            return documentsArray.count + paymentsArray.count + 1
        }else{
            return documentsArray.count + paymentsArray.count
        }
        
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cellIdentifier = "requestCollectionViewCell"
        if selectedIndex == 2 || selectedIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! requestCollectionViewCell
            cell.layoutIfNeeded()
            return cell
        }else{
            if collectionView == paymentCollectionView {
                
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "requestCell", for: indexPath)
                  
                  
                  let paymentLabel = cell.viewWithTag(1) as! UILabel
                  let applyButton = cell.viewWithTag(2) as! UIButton
                
                  cell.layer.cornerRadius = 5
                  cell.layer.masksToBounds = true
                  
                  
                  //let payemntItem = paymentsArray[indexPath.row]
                  
                  paymentLabel.text = "E-Channel is not Registered, Please Register Company for E-Channel. "
                  applyButton.addTarget(self, action: #selector(echannelButton(_:)), for: .touchUpInside)

                  return cell
            }
            if indexPath.section == 0 {
                
                if indexPath.row == 0 {
                    cellIdentifier = "titleCell"
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                    return cell
                }
                cellIdentifier = "payemntCell"
                
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                
                
                //cell.backgroundColor = .red
                paymentCollectionView = cell.viewWithTag(123) as? UICollectionView
                
                paymentCollectionView.delegate = self
                            
                      
                paymentCollectionView.dataSource = self
                             
                            
                paymentCollectionView.showsVerticalScrollIndicator = false
                   
                
                if let layout = paymentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                
                    layout.scrollDirection = .horizontal  // .horizontal
                    
                }
                
                paymentCollectionView.isPagingEnabled = false
                
                paymentCollectionView.reloadData()
                
                paymentCollectionView.setNeedsLayout()
                
                return cell
            }else if indexPath.section == 1 {
                
                
                if indexPath.row == 0 {
                    cellIdentifier = "titleCell"
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                    return cell
                }
                cellIdentifier = "payCell"
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                
                cell.layoutIfNeeded()
                return cell
            }else if indexPath.section == 2 {
                
                if indexPath.row == 0 {
                    cellIdentifier = "titleCell"
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                    return cell
                }
                cellIdentifier = "reqDocumentCell"
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! reqDocumentCell
                return cell
            }
            
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "titleCell" {
            let titleLabel = cell.viewWithTag(1) as! UILabel
            switch indexPath.section {
            case 0:
                titleLabel.text = "E-Channel"
                
                
            case 1:
                titleLabel.text = "Payment Requests"
                
            case 2:
                titleLabel.text = "Required Documents"
            default:
                titleLabel.text = ""
            }
        }
        if cell.reuseIdentifier == "requestCollectionViewCell" {
            let cell = cell as! requestCollectionViewCell
            
            if selectedIndex == 2{
                
                let rItem = submittedRequest[indexPath.row]
                
                cell.serviceName.text = rItem.service_name
                cell.serviceStatus.text = rItem.online_status_name
                cell.serviceDate.text = rItem.create_date
                
                
                
            }else if selectedIndex == 1{
                let rItem = draftRequests[indexPath.row]
                cell.serviceName.text = rItem.application_caption
                cell.serviceStatus.text = rItem.caption
                cell.serviceDate.text = rItem.next_action_time
                
            }
        }
        if cell.reuseIdentifier == "reqDocumentCell" {
            let cell = cell as! reqDocumentCell
            
            
            var item: SAIFZONEDocuments!
            
            
            if indexPath.section == 2 {
                item = documentsArray[indexPath.row - 1]
            }else{
                if eChannelArray.count > 0 {
                    
                    print(indexPath.row )
                    
                    print(indexPath.row - paymentsArray.count - 1)
                    item = documentsArray[indexPath.row - paymentsArray.count - 1]
                }else{
                    item = documentsArray[indexPath.row - paymentsArray.count]
                }
            }
            
            
            cell.servicNameLabel.text = item.ServiceName
            cell.cardLabel.text = item.AttachmentName
            cell.serviceDescriptionLabel.text = item.AttachmentTypeDescription
            
            
            cell.viewController = self
            //cell.changedelegate = self.delegate
            cell.docItem = item
        }
        if cell.reuseIdentifier == "payCell"{
        
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
        
            let paymentLabel = cell.viewWithTag(1) as! UILabel
          
        
            let applyButton = cell.viewWithTag(2) as! UIButton
        
          
            cell.layer.cornerRadius = 5
         
            cell.layer.masksToBounds = true
          
            var paymentItem: SAIFZONEPaymentRequest!
          
            if indexPath.section == 1  {
                paymentItem = paymentsArray[indexPath.row - 1]
            }else {
                if eChannelArray.count > 0 {
                    
                    
                    print(indexPath.row - 1 )
                    paymentItem = paymentsArray[indexPath.row - 1]
                }else{
                   paymentItem = paymentsArray[indexPath.row]
                }
            }
            
         
          
          paymentLabel.text = paymentItem.PaymentCaption + " Amount : \(paymentItem.AmountValue)"
          applyButton.addTarget(self, action: #selector(pressApplyButton), for: .touchUpInside)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndex == 1{
            
            selectedService = draftRequests[indexPath.row]
            selectedServiceURL = AppConstants.WEB_BASIC_URL_TEST_BASE_URL + selectedService.editlink
            
            
            self.performSegue(withIdentifier: "toWebView", sender: self)
        }else if selectedIndex == 0{
            
            
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if selectedIndex == 0{
            
            
            if collectionView == paymentCollectionView {
                return CGSize(width: (paymentCollectionView.frame.width)  , height: 70)
            }
            if indexPath.section == 0 {
                
                if indexPath.row == 0 {
                    return CGSize(width: (collectionView.frame.width), height: 50)
                }
                return CGSize(width: (collectionView.frame.width) - 10 , height: 70)
            }else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    return CGSize(width: (collectionView.frame.width), height: 50)
                }
                return CGSize(width: self.collectionView.frame.width - 40, height: 70)
            }else if indexPath.section == 2 {
                if indexPath.row == 0 {
                    return CGSize(width: (collectionView.frame.width), height: 50)
                }
                return CGSize(width: self.collectionView.frame.width - 40, height: 200)
                
            }else{
                
                if eChannelArray.count > 0 {
                    if indexPath.row == 0  {
                        return CGSize(width: (collectionView.frame.width), height: 70)
                    }
                    
                    if indexPath.row <= paymentsArray.count {
                        return CGSize(width: self.collectionView.frame.width - 40, height: 70)
                    }
                }else{
                    if indexPath.row < paymentsArray.count {
                        return CGSize(width: self.collectionView.frame.width - 40, height: 70)
                    }
                }
                
                
                return CGSize(width: self.collectionView.frame.width - 40, height: 200)
            }
            
        }
        return CGSize(width: self.collectionView.frame.width - 40, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == paymentCollectionView {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == paymentCollectionView {
            return 10.0
        }
        return 30.0
    }
    
    
}


extension requestsViewController :EmptyDataSetSource , EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Requests")
    }
}
