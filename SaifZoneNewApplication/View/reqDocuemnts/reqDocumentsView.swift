//
//  reqDocumentsView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 5/2/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift



class reqDocumentsView: UIView {
    
    
    var viewController: loginPageViewController!
    @IBOutlet var collectionView: UICollectionView!
    var documentsArray: [SAIFZONEDocuments] = []
    var delegate: changeViewProtocol!
    
    var fileUrl = "/AppRecordMP.aspx?bo=1055&EditMode=New&Hidenavigation=1&hidelist=1&HideDelete=1&returnpage=default&dvdocumentid=14&fVSUBJECT=SAIF Zone Employee Card"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "reqDocumentCell", bundle: nil), forCellWithReuseIdentifier: "reqDocumentCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        //collectionView.isPagingEnabled = true
        collectionView.reloadData()
        collectionView.setNeedsLayout()
    }
    
    func loadReqDocuments() {
        self.getRequieredDocuments()
    }
    
    
    func getRequieredDocuments() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.viewController.activityData)
                       
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
    
    
}
extension reqDocumentsView: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  ,EmptyDataSetDelegate , EmptyDataSetSource  {
    
    //MARK: - CollectionView
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Documents")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       
        return documentsArray.count
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "reqDocumentCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! reqDocumentCell
        
        
        
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "reqDocumentCell" {
            let cell = cell as! reqDocumentCell
            
            let item = documentsArray[indexPath.row]
            
            
            cell.servicNameLabel.text = item.ServiceName
            cell.cardLabel.text = item.AttachmentName
            cell.serviceDescriptionLabel.text = item.AttachmentTypeDescription
            
            
            //cell.viewController = self.viewController
            cell.changedelegate = self.delegate
            cell.docItem = item
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: self.collectionView.frame.width - 40, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 30.0
    }
    
    
}
