//
//  newStatmentOfAccountViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 5/12/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift



class newStatmentOfAccountViewController: UIViewController ,loadStatmentsForDates{
    
    let activityData = ActivityData()

    @IBOutlet var payInvoiceButton: UIButton!
    @IBOutlet var downloadStatmentButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    var statmentsArray : [SAIFZONEStatment] = []
    
    
    var selectedStatment: SAIFZONEStatment!
    
    
    var dateFrom: Date?
    var dateTo: Date?
    
    
    var dateFromString: String?
    var dateToString: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        setupCollectionView()
        
        //setupSearch()
        //setupDates()
        
        
        downloadStatmentButton.layer.cornerRadius = 20
        downloadStatmentButton.layer.masksToBounds = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        setupDates()
        var user = SAIFZONEUser.getSAIFZONEUser()
        
        
        if user?.DToken != nil {
            self.payInvoiceButton.isEnabled = true
            self.downloadStatmentButton.isEnabled = true
        }else{
            self.payInvoiceButton.isEnabled = false
            self.downloadStatmentButton.isEnabled = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        
       
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    func setupCollectionView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView = UIView()
        
        tableView.register(UINib(nibName: "newStatmentTableViewCell", bundle: nil), forCellReuseIdentifier: "newStatmentTableViewCell")
        tableView.register(UINib(nibName: "statmentHeaderView", bundle: nil), forCellReuseIdentifier: "statmentHeaderView")
        
        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableView.automaticDimension
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")

        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
     
        tableView.tableFooterView = UIView()
    }

    
    func setupDates() {
        
        
        let dateFormatter = DateFormatter()
        
         dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = Date()
        
        /*
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        let year =  components.year
        let month = components.month
        let day = components.day

        print(year)
        print(month)
        print(day)
        
        */
        
        //dateFrom
        dateTo = date
        dateToString = date.stringFromFormat("yyyy-MM-dd")
        
        
        
   
        
        var comps2 = DateComponents()
        comps2.month = -6
        
        let endOfMonth = Calendar.current.date(byAdding: comps2, to: date)
        print(dateFormatter.string(from: endOfMonth!))
        
        
        dateFrom = endOfMonth
        dateFromString = endOfMonth?.stringFromFormat("yyyy-MM-dd") ?? ""
        
        
        self.tableView.reloadData()
        self.getStatmentOfAccount()
    }
   
    
    func loadDates(fromDate: String, toDate: String) {
        
        self.dateFromString = fromDate
        self.dateToString = toDate
        
        self.getStatmentOfAccount()
    }
    func getStatmentOfAccount() {
        DispatchQueue.main.async {
        
            guard Utilities().isInternetAvailable() == true else{
                Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                return
            }
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
            
            //self.view.isUserInteractionEnabled = false
            
            
        
            var user = SAIFZONEUser.getSAIFZONEUser()
            var statment = ""
            self.statmentsArray = []
            if user != nil {
                
                let stat = UserDefaults.standard.object(forKey: "companyCode") as? String  ?? ""
                statment = stat
                
            }else{
                statment = ""
                self.tableView.reloadData()
            }
            
            WebService.getStatment(company_code: statment, date_from: self.dateFromString ?? "", date_to: self.dateToString ?? "") { (json) in
                
                print(json)
                
                DispatchQueue.main.async {
                
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                }
                
                guard let code = json["ErrorCode"] as? Int else {return}
                guard let message = json["Message"] as? String else {return}
                guard let data = json["Data"] as? [[String:Any]] else {return}
                
                self.statmentsArray = []
                for  obj in data {
                     let statItem = SAIFZONEStatment()
                    statItem.trDate = String(describing: obj["trDate"] ?? "")
                    statItem.TransactionRef = String(describing:obj["TransactionRef"] ?? "")
                    statItem.descriptionStat = String(describing:obj["description"] ?? "" )
                    statItem.Debit = String(describing: obj["Debit"] ?? "" )
                    statItem.Credit = String(describing: obj["Credit"] ?? "")
                    statItem.PDC = String(describing: obj["PDC"] ?? "")
                    statItem.Balance = String(describing: obj["Balance"]  ?? "")
                    statItem.StrDate = String(describing:obj["StrDate"] ?? "" )
                   
                    
                    self.statmentsArray.append(statItem)
                    
                    
                  
                }
                
                
                DispatchQueue.main.async {
                    
                 
                    self.tableView.reloadData()

                    self.tableView.layoutIfNeeded()
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
            }
            
        }
    }
    
  
    @IBAction func downloadStatmentAction(_ sender: Any) {
        
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
            return
        }
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
        
        
        WebService.getDownloadStatmentForAll(startDate: dateFromString ?? "", endDate: dateToString ?? "") { (json) in
            
            print(json)
            
            
            DispatchQueue.main.async {
            
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
            guard let id = json["d"] as? String else {return}
            
            
            DispatchQueue.main.async {
                if let fileUrl = URL(string: "\(AppConstants.WEB_SERVER_DOWNLOAD_LINK_FILE_TEST)?FileID=\(id)&download=1") {
                    
                    print("the file to be downloaded is : \(fileUrl)")
                    
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    print("docdir" + String(describing: documentsDirectory))
                    let dataPath = documentsDirectory.appendingPathComponent("SAIFZONE docs")
                    
                    //let fileExists = FileManager().fileExists(atPath: dataPath.path)
                    
                    let destination = documentsDirectory.appendingPathComponent( "\(id).PDF")
                    //Downloader1.load(url: fileUrl, to: destination) {
                        
                  //  }
                    Downloader.load(filePath: destination, viewController: self, url: fileUrl) { (data) in
                        
                        DispatchQueue.main.async {
                            Utils.showAlertWith(title: "Success", message: "the file has been downloaded ,you can see it in files application", viewController: self)
                        }
                        
                    }
                }
            }
        }
    }
    
    @objc func getDownloadId() {
        
        
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
            return
        }
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
        
        
        WebService.getDownloadStatmentId(recept_number: self.selectedStatment.TransactionRef ?? "") { (json) in
            
            print(json)
            
            
            DispatchQueue.main.async {
            
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
            guard let id = json["d"] as? String else {return}
            
            
            DispatchQueue.main.async {
                if let fileUrl = URL(string: "\(AppConstants.WEB_SERVER_DOWNLOAD_LINK_FILE_TEST)?FileID=\(id)&download=1") {
                    
                    print("the file to be downloaded is : \(fileUrl)")
                    
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    
                    print("docdir" + String(describing: documentsDirectory))
                    let dataPath = documentsDirectory.appendingPathComponent("SAIFZONE docs")
                    
                    //let fileExists = FileManager().fileExists(atPath: dataPath.path)
                    
                    let destination = documentsDirectory.appendingPathComponent( "\(id).PDF")
                    //Downloader1.load(url: fileUrl, to: destination) {
                        
                  //  }
                    Downloader.load(filePath: destination, viewController: self, url: fileUrl) { (data) in
                        
                        DispatchQueue.main.async {
                            Utils.showAlertWith(title: "Success", message: "the file has been downloaded ,you can see it in files application", viewController: self)
                        }
                        
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tofilterPage" {
            
            let dest = segue.destination as! filterPageViewwController
            dest.delegate = self
            
        }
    }
}
extension newStatmentOfAccountViewController: UITableViewDelegate , UITableViewDataSource , EmptyDataSetDelegate , EmptyDataSetSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if statmentsArray.count > 0 {
            return statmentsArray.count + 1
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            
            let view = tableView.dequeueReusableCell(withIdentifier: "statmentHeaderView", for: indexPath) as! statmentHeaderView
            
            view.viewController = self
            
            view.delegate = self
            
            if view.fromDateString == nil{
                view.fromDateString = dateFromString
                view.fromDate = dateFrom
            }
            
            if view.toDateString == nil{
                view.toDateString = dateToString
                view.toDate = dateTo
            }
            view.fromButton.setTitle(dateFromString ?? "", for: .normal)
            view.toButton.setTitle(dateToString ?? "", for: .normal)
            
            return view
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "newStatmentTableViewCell", for: indexPath) as! newStatmentTableViewCell
        
        
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "newStatmentTableViewCell" {
            let cell = cell as! newStatmentTableViewCell
            let item = statmentsArray[indexPath.section - 1]
            
            cell.selectStatment = item
            cell.statmentViewController = self
            let isoDate = "2016-04-14T10:44:00"

            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from:item.trDate)
            if date != nil {
                cell.statmentCaption.text = date?.stringFromFormat("yyyy-MM-dd")
            }else{
                cell.statmentCaption.text = item.trDate == "<null>" ? "N/A" : item.trDate.components(separatedBy: "T")[0]
            }
            
            cell.dateLabel.text = item.TransactionRef == "<null>" ? "N/A" : item.TransactionRef
            cell.statmentDescriptionLabel.text = item.descriptionStat == "<null>" ? "N/A" : item.descriptionStat
            cell.debitLabel.text = item.Debit == "<null>" ? "N/A" : item.Debit
            cell.creditLabel.text = item.Credit == "<null>" ? "N/A" : item.Credit
            cell.pdcLabel.text = item.PDC == "<null>" ? "N/A" : item.PDC
            cell.balanceLabel.text = item.Balance == "<null>" ? "N/A" : item.Balance
            
            
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            
            
        }
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Statments")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        if section == 1 {
            return 10
        }
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
        
        
        
        selectedStatment = statmentsArray[indexPath.section - 1]
        if selectedStatment.TransactionRef != "<null>" {
           //download statment
            
            
            let logOutAlertActionController = UIAlertController(title:"", message: NSLocalizedString("do you want to downlaod this file ?", comment:""), preferredStyle: .alert )
                   
                   
            let yesAlerActionOption = UIAlertAction(title:NSLocalizedString("Yes",comment:""), style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
                  
                self.getDownloadId()
                
            })
            
            let noAlertActionOption = UIAlertAction(title:NSLocalizedString("No",comment:""), style: .default, handler: nil)
            
            logOutAlertActionController.addAction(yesAlerActionOption)
            logOutAlertActionController.addAction(noAlertActionOption)
            
            self.present(logOutAlertActionController, animated: true, completion: nil)
            
        }else{
            
        }
    }
}
 
