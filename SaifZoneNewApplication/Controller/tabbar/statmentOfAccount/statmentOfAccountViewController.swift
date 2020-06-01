//
//  statmentOfAccountViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 4/27/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import EmptyDataSet_Swift
import NVActivityIndicatorView



protocol loadStatmentsForDates {
    func loadDates(fromDate: String  , toDate: String)
}
class statmentOfAccountViewController: UIViewController ,loadStatmentsForDates{
    
    let activityData = ActivityData()
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    var searchbarOutlet: UIBarButtonItem!
    var isSearchAdded = false
    var searchText = ""
    var searchActive : Bool = false
    
    
    var statmentsArray : [SAIFZONEStatment] = []
    
    
    
    var dateFrom: Date?
    var dateTo: Date?
    
    
    var dateFromString: String?
    var dateToString: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupView()
        setupCollectionView()
        
        //setupSearch()
        //setupDates()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        setupDates()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        
        if isSearchAdded {
            
            
            self.navigationItem.title = "Statment of Account"
            self.searchBar.alpha = 0
            self.searchText = ""
            self.isSearchAdded = false
            
        }
        
    }
    
    func setupView() {
        
        searchbarOutlet = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchbarOutlet(_:)))
        
        
        //self.navigationItem.rightBarButtonItems = [searchbarOutlet]
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: "statmentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "statmentCollectionViewCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        //collectionView.isPagingEnabled = true
        collectionView.reloadData()
        collectionView.setNeedsLayout()
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
        
        
        
        fromLabel.text = "from: \(dateFromString ?? "")"
        toLabel.text = "to: \(dateToString ?? "")"
        
        
        self.getStatmentOfAccount()
    }
    
    @objc func searchbarOutlet(_ sender: Any) {
        
        if isSearchAdded {
            
            
            UIView.animate(withDuration: 0.7, delay: 0.0, options: .transitionFlipFromRight, animations: {
                self.navigationItem.title = "Statment of Account"
                
                self.searchBar.alpha = 0
            }) { (finished) in
                
                
                self.searchText = ""
                self.isSearchAdded = false
            }
            
            
            
        }else {
            
            
            UIView.animate(withDuration: 0.7, delay: 0.0, options: .transitionFlipFromBottom, animations: {
                
                self.navigationItem.titleView = self.searchBar
                self.searchBar.alpha = 1
                
            }) { (finished) in
                
                self.searchText = ""
                self.isSearchAdded = true
            }
            
            
        }
    }
    
    func setupSearch() {
        searchBar.delegate = self
        
        searchBar.showsCancelButton = true
        
        
        /*
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textAlignment = AppConstants.isArabic() ? .right : .left
        }
        */
        
    
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
                self.collectionView.reloadData()
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
                    statItem.trDate = obj["trDate"] as? String ?? ""
                    statItem.TransactionRef = obj["TransactionRef"] as? String ?? ""
                    statItem.descriptionStat = obj["description"] as? String ?? ""
                    statItem.Debit = obj["Debit"] as? String ?? ""
                    statItem.Credit = obj["Credit"] as? String ?? ""
                    statItem.PDC = obj["PDC"] as? String ?? ""
                    statItem.Balance = obj["Balance"] as? String ?? ""
                    statItem.StrDate = obj["StrDate"] as? String ?? ""
                   
                    
                    self.statmentsArray.append(statItem)
                    
                    
                  
                }
                
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    @IBAction func filterAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "tofilterPage", sender: self)
    }
    
    
    @IBAction func dwonloadStatmentAction(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tofilterPage" {
            
            let dest = segue.destination as! filterPageViewwController
            dest.delegate = self
            
        }
    }
}



extension statmentOfAccountViewController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  , EmptyDataSetDelegate , EmptyDataSetSource {
    
    //MARK: - CollectionView
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Statments")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       
        return statmentsArray.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "statmentCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! statmentCollectionViewCell
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "statmentCollectionViewCell" {
            let cell = cell as! statmentCollectionViewCell
            let rItem = statmentsArray[indexPath.row]
            cell.viewController = self
            cell.statmentItem = rItem
            cell.descriptionLabel.text = rItem.descriptionStat
            cell.transactionLabel.text = rItem.TransactionRef
            cell.balanceLabel.text = rItem.Balance
                     
            cell.showDownloadbutton()
            
            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        
        let sItem = statmentsArray[indexPath.row]
        
        let labelStringDesc = NSAttributedString(string: sItem.descriptionStat, attributes: [.font : UIFont.systemFont(ofSize: 15)])
        let labelStringBalance = NSAttributedString(string: sItem.Balance, attributes: [.font : UIFont.systemFont(ofSize: 15)])
            
        let cellrectDesc = labelStringDesc.boundingRect(with: CGSize(width:  self.collectionView.frame.width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        let cellrectBalance = labelStringBalance.boundingRect(with: CGSize(width:  self.collectionView.frame.width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return CGSize(width: self.collectionView.frame.width - 40, height: cellrectDesc.height + cellrectBalance.height + 160)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        return 30.0
    }
    
    
}
extension statmentOfAccountViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        
        searchText = searchBar.text ?? ""
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false;
        searchText = searchBar.text ?? ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .transitionFlipFromRight, animations: {
            self.navigationItem.title = "Satatment of Account"
            
            self.searchBar.alpha = 0
        }) { (finished) in
            
            self.searchText = ""
            self.isSearchAdded = false
            
            
            
            
        }
        
        searchBar.endEditing(true)
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
         
        
         searchText = searchBar.text ?? ""
         self.searchBar.endEditing(true)
        
        
        //search and filter array
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}
