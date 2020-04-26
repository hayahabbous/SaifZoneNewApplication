//
//  ServicesViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/9/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift

class ServicesViewController: UIViewController ,endSearch {
    
    
    func userDidClickSearch() {
        
        let text = self.searchController.searchBar.text ?? ""
        if var service = allServicesArray.filter({ (s) -> Bool in
            s.Caption.lowercased() == text.lowercased()
        }).first {
            
            var seqArray = [SAIFZONEService]()
            selectedService = service
            
            while service.Parent != "0" {
                seqArray.append(service)
                 print(service.Caption)
                service = allServicesArray.filter({ (parent) -> Bool in
                    parent.SID == service.Parent
                    }).first!
                
            }
            
            seqArray.append(service)
             
            print(service.Caption)
            
            //sort this array according to id
            
            seqArray.sort { (s1, s2) -> Bool in
                s1.SID < s2.SID
            }
            
            
            selectedMainService = mainServicesArray.filter({ (mainItem) -> Bool in
                mainItem.SCID == seqArray[0].Category
                }).first!
            
            self.tableView.reloadData()
        
            
            //check count of this array
            /*
            
            if seqArray.count == 1 {
                isMainServiceSelected = true
                selectedService = seqArray[0]
                
                
                self.firstButton.setTitle(self.selectedMainService.Caption, for: .normal)
                firstButtonAction(self)
                
                
            }else */
            
            if seqArray.count == 1 {
                isMainServiceSelected = false
                selectedService = seqArray[0]
                firstSelectedItem = selectedService
                self.firstButton.setTitle(self.selectedMainService.Caption, for: .normal)
                self.secondButton.setTitle(self.selectedService.Caption, for: .normal)
                secondButtonAction(self)
                
            }else if seqArray.count == 2 {
                isMainServiceSelected = false
                selectedService = seqArray[1]
                firstSelectedItem = seqArray[0]
                secondSelectedItem = seqArray[1]
                
                
                self.firstButton.setTitle(self.selectedMainService.Caption, for: .normal)
                self.secondButton.setTitle(self.firstSelectedItem?.Caption, for: .normal)
                self.thirdButton.setTitle(self.selectedService.Caption, for: .normal)
                thirdButtonAction(self)
                
            }
            else if seqArray.count == 3 {
                isMainServiceSelected = false
                selectedService = seqArray[2]
                firstSelectedItem = seqArray[0]
                secondSelectedItem = seqArray[1]
                thirdSelectedItem = seqArray[2]
                
                self.firstButton.setTitle(self.selectedMainService.Caption, for: .normal)
                self.secondButton.setTitle(self.firstSelectedItem?.Caption, for: .normal)
                self.thirdButton.setTitle(self.secondSelectedItem?.Caption, for: .normal)
                self.fourthButton.setTitle(self.selectedService.Caption, for: .normal)
                fourthButtonAction(self)
                
            }
            
            self.servicesCollectionView.reloadData()
        }
        self.searchController.searchBar.text = ""
        self.updateSearchResults(for: self.searchController)
        self.searchBarCancelButtonClicked(self.searchController.searchBar)
        self.definesPresentationContext = true
        self.searchController.isActive = false
    }
    
    
    var endSerachDelegate: endSearch!
    var selectedServiceURL: String!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    @IBOutlet var fourthButton: UIButton!
    
    
    @IBOutlet var firstArrowImageView: UIImageView!
    @IBOutlet var secondArrowImageView: UIImageView!
    @IBOutlet var thirdArrowImageView: UIImageView!
    
    
    
    
    var firstSelectedItem: SAIFZONEService?
    var secondSelectedItem: SAIFZONEService?
    var thirdSelectedItem: SAIFZONEService?
    
    var mainServicesArray: [SAIFZONEMainService] = []
    var allServicesArray: [SAIFZONEService] = []
    
    var selectedMainService: SAIFZONEMainService = SAIFZONEMainService()
    var selectedService: SAIFZONEService = SAIFZONEService()
    let activityData = ActivityData()
    @IBOutlet var servicesCollectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    
    var isMainServiceSelected = true
    
    
     var searchController: UISearchController!
     let resultsContainerViewController =
        ResultsContainerViewController()
    private var searchType: SearchType = .final
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        setupView()
        getMainServices()
        getAllServices()
        
        
        
        
        //tableView.emptyDataSetSource = self
        //tableView.emptyDataSetDelegate = self
        
        
        
    }
    
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.tableFooterView = UIView()
        setupCollectionView()
        
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
        
        secondButton.isHidden = true
        thirdButton.isHidden = true
        fourthButton.isHidden = true
        
        firstArrowImageView.isHidden = true
        secondArrowImageView.isHidden = true
        thirdArrowImageView.isHidden = true
        
        self.firstButton.setTitle("", for: .normal)
        self.firstButton.setTitleColor( UIColor(red: 55/256, green: 30/256, blue: 52/256, alpha: 1.0), for: .normal)
        self.secondButton.setTitleColor(.darkGray, for: .normal)
        self.thirdButton.setTitleColor(.darkGray, for: .normal)
        
        
        
        
        extendedLayoutIncludesOpaqueBars = true
        setSearchController()
        navigationController?.navigationBar.setShadow(hidden: true)
        
    }
    private func setSearchController() {
        searchController = UISearchController(
            searchResultsController: resultsContainerViewController
        )
        resultsContainerViewController.didSelect = search
        resultsContainerViewController.ServicesVC = self
        resultsContainerViewController.ServicesVC.endSerachDelegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    /// A final search has been triggered either by tapping search, tapping
    /// a trending term or tapping a suggestion.
    ///
    /// - Parameter term: Term to search on the App Store.
    private func search(term: String) {
        searchController.searchBar.text = term
        searchType = .final
        searchController.isActive = true
        searchController.searchBar.resignFirstResponder()
        navigationController?.navigationBar.setShadow(hidden: false)
    }
    
    func getMainServices() {
        
        
        
        DispatchQueue.main.async {
            
            
            guard Utilities().isInternetAvailable() == true else{
                Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                return
            }
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
            //self.view.isUserInteractionEnabled = false
        }
        
        WebService.getMainServices { (json) in
            
            print(json)
            DispatchQueue.main.async {
                 NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                //self.view.isUserInteractionEnabled = false
            }
            
            guard let data = json["Data"] as? [[String:Any]] else {return}
            
            
            self.mainServicesArray = []
            for result in data {
             
                var mainItem = SAIFZONEMainService()
                mainItem.SCID = result["SCID"] as? String ?? ""
                mainItem.Caption = result["Caption"] as? String ?? ""
                
                
                self.mainServicesArray.append(mainItem)
                
            }
            DispatchQueue.main.async {
                
                self.selectedMainService = self.mainServicesArray[0]
                AppConstants.mainServicesArray = self.mainServicesArray
                self.firstButton.setTitle(self.selectedMainService.Caption, for: .normal)
                
                self.tableView.reloadData()
            }
            
        }
        
    }
    func getAllServices() {
        DispatchQueue.main.async {
            
            guard Utilities().isInternetAvailable() == true else{
                Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                return
            }
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
            //self.view.isUserInteractionEnabled = false
        }
        
        WebService.getServices { (json) in
            
            print(json)
            DispatchQueue.main.async {
                 NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                //self.view.isUserInteractionEnabled = false
            }
            
            guard let data = json["Data"] as? [[String:Any]] else {return}
            
            
            self.allServicesArray = []
            for result in data {
             
                let mainItem = SAIFZONEService()
                mainItem.SID = result["SID"] as? String ?? ""
                mainItem.Caption = result["Caption"] as? String ?? ""
                
                mainItem.ApplicationID = result["ApplicationID"] as? String ?? ""
                mainItem.Description = result["Description"] as? String ?? ""
                mainItem.Price = result["Price"] as? String ?? ""
                mainItem.Category = result["Category"] as? String ?? ""
                mainItem.UrgentPrice = result["UrgentPrice"] as? String ?? ""
                mainItem.Duration = result["Duration"] as? String ?? ""
                mainItem.Sequence = result["Sequence"] as? String ?? ""
                mainItem.RequiredDocuments = result["RequiredDocuments"] as? String ?? ""
                mainItem.Parent = result["Parent"] as? String ?? ""
                mainItem.SubLevel = result["SubLevel"] as? String ?? ""
                
                mainItem.URL1 = result["URL1"] as? String ?? ""
                mainItem.URL2 = result["URL2"] as? String ?? ""
                
                self.allServicesArray.append(mainItem)
                
            }
            
            
            
            DispatchQueue.main.async {
                var _: [SAIFZONEService] = []
                
                
                //add sub to main
                let array = self.allServicesArray.filter { (item) -> Bool in
                    item.Parent == "0"
                }
                
                for result in array {
                    
                    //get category of this result
                    let category =  result.Category
                    
                    let mainItem = self.mainServicesArray.filter { (item) -> Bool in
                        item.SCID == category
                    }.first
                    
                    
                    
                    mainItem?.relatedServicesArray.append(result)
                    
                
                }
                
                //add sub to sub
                
                
                for result in self.allServicesArray {
                    var scid = result.SID
                    if scid == "94" {
                        print(result.Caption)
                    }
                    
                    //search if this item has children
                    var itemArray = self.allServicesArray.filter { (subitem) -> Bool in
                        subitem.Parent == scid
                    }
                
                    result.relatedServicesArray = itemArray
                }
                
                AppConstants.allServicesArray = self.allServicesArray
                self.servicesCollectionView.reloadData()
            }
            
        }
    }
    func setupCollectionView() {
        
        
        
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        
        servicesCollectionView.showsVerticalScrollIndicator = false
        
        servicesCollectionView.register(UINib(nibName: "serviceMainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "serviceMainCollectionViewCell")
        
        
        servicesCollectionView.register(UINib(nibName: "applyServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "applyServiceCollectionViewCell")
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = servicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        servicesCollectionView.emptyDataSetSource = self
        servicesCollectionView.emptyDataSetDelegate = self
        servicesCollectionView.isPagingEnabled = true
        servicesCollectionView.reloadData()
        servicesCollectionView.setNeedsLayout()
    }
    @IBAction func firstButtonAction(_ sender: Any) {
        
        isMainServiceSelected = true
        
        firstButton.isHidden = false
        secondButton.isHidden = true
        thirdButton.isHidden = true
        fourthButton.isHidden = true
        
        firstArrowImageView.isHidden = true
        secondArrowImageView.isHidden = true
        thirdArrowImageView.isHidden = true
        

        
        self.firstButton.setTitleColor( UIColor(red: 55/256, green: 30/256, blue: 52/256, alpha: 1.0), for: .normal)
        self.secondButton.setTitleColor(.darkGray, for: .normal)
        self.thirdButton.setTitleColor(.darkGray, for: .normal)
        self.fourthButton.setTitleColor(.darkGray, for: .normal)
        
        
        self.firstButton.setTitle(self.selectedMainService.Caption, for: .normal)
        self.servicesCollectionView.reloadData()
        self.tableView.reloadData()
               
        
    }
    @IBAction func secondButtonAction(_ sender: Any) {
        
        firstButton.isHidden = false
        secondButton.isHidden = false
        
     
        thirdButton.isHidden = true
        fourthButton.isHidden = true
        
        firstArrowImageView.isHidden = false
        secondArrowImageView.isHidden = true
        thirdArrowImageView.isHidden = true
        
        self.secondButton.setTitleColor( UIColor(red: 55/256, green: 30/256, blue: 52/256, alpha: 1.0), for: .normal)
        self.firstButton.setTitleColor(.darkGray, for: .normal)
        self.thirdButton.setTitleColor(.darkGray, for: .normal)
        self.fourthButton.setTitleColor(.darkGray, for: .normal)
        
        
        selectedService = firstSelectedItem ?? selectedService
        
        secondSelectedItem = nil
        thirdSelectedItem = nil
        
        
        self.servicesCollectionView.reloadData()
    }
    @IBAction func thirdButtonAction(_ sender: Any) {
        
        firstButton.isHidden = false
      
        secondButton.isHidden = false
        thirdButton.isHidden = false
        fourthButton.isHidden = true
        
        firstArrowImageView.isHidden = false
        secondArrowImageView.isHidden = false
        thirdArrowImageView.isHidden = true
        
        
        self.thirdButton.setTitleColor( UIColor(red: 55/256, green: 30/256, blue: 52/256, alpha: 1.0), for: .normal)
        self.secondButton.setTitleColor(.darkGray, for: .normal)
        self.thirdButton.setTitleColor(.darkGray, for: .normal)
        self.fourthButton.setTitleColor(.darkGray, for: .normal)
        
  
        selectedService = secondSelectedItem ?? selectedService
        thirdSelectedItem = nil
        
        self.servicesCollectionView.reloadData()
    }
    @IBAction func fourthButtonAction(_ sender: Any) {
        
        
        firstButton.isHidden = false
        secondButton.isHidden = false
      
        thirdButton.isHidden = false
        fourthButton.isHidden = false
        
        
        firstArrowImageView.isHidden = false
        secondArrowImageView.isHidden = false
        thirdArrowImageView.isHidden = false
        self.fourthButton.setTitleColor( UIColor(red: 55/256, green: 30/256, blue: 52/256, alpha: 1.0), for: .normal)
        
        self.firstButton.setTitleColor(.darkGray, for: .normal)
        self.secondButton.setTitleColor(.darkGray, for: .normal)
        self.thirdButton.setTitleColor(.darkGray, for: .normal)
        
        
        
        selectedService = thirdSelectedItem ?? selectedService
        self.servicesCollectionView.reloadData()
    }
    
    @objc func openService() {
        
        
        
        if selectedService.URL1.count > 0 && selectedService.URL2 != ""{
            
            selectedServiceURL = "https://mportal.saif-zone.com" + selectedService.URL1
        }else if selectedService.URL2.count > 0 && selectedService.URL2 != ""  {
            selectedServiceURL = "https://mportal.saif-zone.com" + selectedService.URL2
        }else {
            selectedServiceURL = "https://mportal.saif-zone.com/AppRecordMP.aspx?bo=\(selectedService.ApplicationID)&EditMode=New&hidelist=1&hidenavigation=1&HideDelete=1"
        }
        
        
        self.performSegue(withIdentifier: "toWebView", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView"  {
            
            let dest = segue.destination as! UINavigationController
            let wv = dest.viewControllers[0] as! webViewController
            wv.selectedServiceURL = self.selectedServiceURL
            
            
        }
    }
}

extension ServicesViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainServicesArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMainService = self.mainServicesArray[indexPath.row]
        self.isMainServiceSelected = true
        
        self.firstButton.setTitle(self.selectedMainService.Caption, for: .normal)
        firstButtonAction(self)
        self.servicesCollectionView.reloadData()
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(red: 187/256, green: 156/256, blue: 98/256, alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(red: 55/256, green: 30/256, blue: 52/256, alpha: 1.0)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "Cell" {
            let imageView = cell.viewWithTag(1) as! UIImageView
            let descLabel = cell.viewWithTag(2) as! UILabel
            
            switch indexPath.row {
            case 0:
                imageView.image = UIImage(named: "investor")
                descLabel.text = "About Us"
            case 1:
                imageView.image = UIImage(named: "finance")
                descLabel.text = "Profile"
            case 2:
                imageView.image = UIImage(named: "license")
                descLabel.text = "License Details"
            case 3:
                imageView.image = UIImage(named: "visitor")
                descLabel.text = "Statment of Account"
            case 4:
                imageView.image = UIImage(named: "health")
                descLabel.text = "E-Services"
            case 5:
                imageView.image = UIImage(named: "security")
                descLabel.text = "Visa Status"
            case 6:
                imageView.image = UIImage(named: "maintainance")
                descLabel.text = "Request"
            case 7:
                imageView.image = UIImage(named: "purchase")
                descLabel.text = "Settings"
            case 8:
                imageView.image = UIImage(named: "sales")
                descLabel.text = ""
            default:
                print("")
            }
            let item = mainServicesArray[indexPath.row]
            if selectedMainService.SCID == item.SCID {
                cell.contentView.backgroundColor = UIColor(red: 187/256, green: 156/256, blue: 98/256, alpha: 1.0)
            }else{
                cell.contentView.backgroundColor = UIColor(red: 55/256, green: 30/256, blue: 52/256, alpha: 1.0)
            }
            
            
            descLabel.text = mainServicesArray[indexPath.row].Caption
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
}
extension ServicesViewController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //MARK: - CollectionView
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

       
        
        if isMainServiceSelected {
            return selectedMainService.relatedServicesArray.count
        }else{
            
            if selectedService.relatedServicesArray.count == 0 {
                return 1
            }else{
                return selectedService.relatedServicesArray.count
            }
            
        }
        
   

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cellIdentifier = "Cell"
        
        
        
        if collectionView == self.servicesCollectionView  {
            
            
            if !isMainServiceSelected {
                if selectedService.relatedServicesArray.count == 0 {
                    cellIdentifier = "applyServiceCollectionViewCell"
                    
                    
                    
                    let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! applyServiceCollectionViewCell
                    
                    cell.titleLabel.text = selectedService.Caption
                    cell.descriptionLabel.text = selectedService.Description == "" ? selectedService.Caption : selectedService.Description
                    
                    cell.priceLabel.text = selectedService.Price == "" ? "Free" : selectedService.Price
                    
                    
                    cell.applyButton.addTarget(self, action: #selector(openService), for: .touchUpInside)
                    
                    return cell
                }
            }
            cellIdentifier = "serviceMainCollectionViewCell"
                   
                   
            let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! serviceMainCollectionViewCell
            
            var item: SAIFZONEService!
            if isMainServiceSelected {
                item = selectedMainService.relatedServicesArray[indexPath.row]
            }else{
                item = selectedService.relatedServicesArray[indexPath.row]
            }
            cell.serviceImageView.image = UIImage(named: "support")
            cell.serviceCaptionLabel.text = item.Caption
            cell.layoutIfNeeded()
            
            return cell
        }
        
        
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if isMainServiceSelected {
            self.selectedService = selectedMainService.relatedServicesArray[indexPath.row]
            self.isMainServiceSelected = false
            self.secondButton.setTitle(self.selectedService.Caption, for: .normal)
        
            firstSelectedItem = selectedService
            self.secondButtonAction(self)
            self.servicesCollectionView.reloadData()
        }else{
            
            if selectedService.relatedServicesArray.count > 0 {
                self.selectedService = selectedService.relatedServicesArray[indexPath.row]
                
                self.isMainServiceSelected = false
                
                
                
                if secondSelectedItem == nil {
                    secondSelectedItem = selectedService
                    self.thirdButton.setTitle(self.selectedService.Caption, for: .normal)
                    self.thirdButtonAction(self)
                }else if thirdSelectedItem == nil {
                    thirdSelectedItem = selectedService
                    self.fourthButton.setTitle(self.selectedService.Caption, for: .normal)
                    self.fourthButtonAction(self)
                }
                
                /*
                self.thirdButton.setTitle(self.selectedService.Caption, for: .normal)
                self.thirdButtonAction(self)
                
                */
                
                
                
                /*
                if secondSelectedItem == nil {
                    
                    secondSelectedItem = selectedService.relatedServicesArray[indexPath.row]
                   

                }else{
                    thirdSelectedItem = selectedService.relatedServicesArray[indexPath.row]
                    self.fourthButton.setTitle(self.selectedService.Caption, for: .normal)
                    self.fourthButtonAction(self)

                }
                     */
                self.servicesCollectionView.reloadData()
            }
            
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        if collectionView == self.servicesCollectionView  {
            
            
            if !isMainServiceSelected {
                           
                if selectedService.relatedServicesArray.count == 0 {
                
                    return CGSize(width: (collectionView.frame.width)   , height: (collectionView.frame.height))
                }
            }
            return CGSize(width: (collectionView.frame.width) / 2 - 30  , height: (collectionView.frame.width) / 2 - 30)
            
        }
        
        return CGSize(width: 150, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == servicesCollectionView {
            return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        }
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == servicesCollectionView {
            return 15
            
        }
        return 10.0
    }
    
    
}


extension ServicesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchType = searchText.isEmpty ? .final : .partial
        navigationController?.navigationBar
            .setShadow(hidden: searchText.isEmpty)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.navigationBar.setShadow(hidden: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        search(term: text)
    }
}

extension ServicesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
            !text.isEmpty else {
                return
        }
        resultsContainerViewController.handle(
            term: text,
            searchType: searchType
        )
    }
}

extension ServicesViewController: EmptyDataSetSource , EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        
        let user = SAIFZONEUser.getSAIFZONEUser()
        
        var font = UIFont.systemFont(ofSize: (15))
        if user?.DToken != nil {
           return NSAttributedString(string: "No Services")
        }else{
            return NSAttributedString(string: "Please signin to show our services ." , attributes: [.font:font ,NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let user = SAIFZONEUser.getSAIFZONEUser()
        
        
        if user?.DToken != nil {
            
            return NSAttributedString(string: "")
        }else{
            return NSAttributedString(string: "signin")
        }
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        let user = SAIFZONEUser.getSAIFZONEUser()
        
        
        if user?.DToken != nil {
            
        }else{
            
        }
    }
}
