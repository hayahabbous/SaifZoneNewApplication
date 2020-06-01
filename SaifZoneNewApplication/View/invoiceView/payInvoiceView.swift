//
//  payInvoiceView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 5/3/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class payInvoiceView: UIView {
    
    
    @IBOutlet var collectionView: UICollectionView!
    var viewController: loginPageViewController!
    var user = SAIFZONEUser.getSAIFZONEUser()
    
    var invoicesArray: [SAIFZONEInvoice] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    
    func loadInvoice(){
        getPayInvoices()
    }
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "payInvoiceCell", bundle: nil), forCellWithReuseIdentifier: "payInvoiceCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        //collectionView.isPagingEnabled = true
        collectionView.reloadData()
        collectionView.setNeedsLayout()
    }
    
    
    func getPayInvoices() {
        
        
        DispatchQueue.main.async {
                          
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.viewController.activityData)
                  
        }
        
        
        let date = Date()
        
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        let year =  String(describing: components.year ?? 0)
        let month = String(describing: components.month ?? 0)
        let day = String(describing: components.day ?? 0)

        print(year)
        print(month)
        print(day)
        
        
        
        
        WebService.payInvoices(year: year, month: month, day: day, company_code: "112207131") { (json) in
            
            print(json)
            
            DispatchQueue.main.async {
                guard Utilities().isInternetAvailable() == true else{
                
                    //Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    
                    return
                    
                }
                          
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
            guard let message  = json["Message"] as? String else {return}
            guard let errorCode  = json["ErrorCode"] as? Int else {return}
            guard let data  = json["Data"] as? [[String:Any]] else {return}
            
            self.invoicesArray = []
            for obj in data {
                let item = SAIFZONEInvoice()
                item.machineid = String(describing: obj["machineid"]  ?? "")
                item.ddtransaction = String(describing: obj["ddtransaction"]  ?? "" )
                item.transnr = String(describing: obj["transnr"]  ?? "" )
                item.ddinvoice = String(describing: obj["ddinvoice"]  ?? "" )
                item.ddduedate = String(describing: obj["ddduedate"]   ?? "" )
                item.aatransaction = String(describing: obj["aatransaction"]  ?? "" )
                item.cname = String(describing: obj["cname"]   ?? "" )
                item.customercode = String(describing: obj["customercode"]  ?? "" )
                item.contractnr = String(describing: obj["contractnr"]  ?? "" )
                item.licensenr = String(describing: obj["licensenr"]  ?? "" )
                item.phone = String(describing: obj["phone"]  ?? "" )
                item.pobox = String(describing: obj["pobox"]  ?? "" )
                
                
                
                item.address = obj["address"] as? String ?? ""
                item.email = obj["email"] as? String ?? ""
                item.transtype = obj["transtype"] as? String ?? ""
                
                
                self.invoicesArray.append(item)
                
                
                
                
            }
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        
        }
        
    }
    
    
}

extension payInvoiceView: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       
        return invoicesArray.count
        

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "payInvoiceCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! payInvoiceCell
        
        
        
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "payInvoiceCell" {
            let cell = cell as! payInvoiceCell
            
            let item = invoicesArray[indexPath.row]
            
            
            cell.transactionDateLabel.text = item.ddtransaction
            cell.transactionNumberLabel.text = item.transnr
            cell.transactionAmountLabel.text = item.aatransaction + " AED"
            
            
            cell.viewController = self.viewController
            cell.invoiceItem = item
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: self.collectionView.frame.width - 40, height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 30.0
    }
    
    
}

