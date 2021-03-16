//
//  HomePageViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/3/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import JJFloatingActionButton
import NVActivityIndicatorView

class HomePageViewController: UIViewController {
    
    
    @IBOutlet var scrollView: UIScrollView!
    var infoCollectionView: UICollectionView!
    var socialCollectionView: UICollectionView!
    @IBOutlet var circularImageView: UIImageView!
    @IBOutlet var backImageView: UIImageView!

    var newsItem: [SAIFZONENews] = []
    var selectedNews: SAIFZONENews = SAIFZONENews()
    @IBOutlet var mainCollectionView: UICollectionView!
    @IBOutlet var parentProfileImageView: UIImageView!
    
    let activityData = ActivityData()
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        circularImageView.layer.cornerRadius = self.circularImageView.frame.height / 2
        
        circularImageView.layer.masksToBounds = true
        backImageView.addCurvedView(imageview: backImageView ,backgroundColor: UIColor(red: 205/255, green: 175/255, blue: 116/255, alpha: 1.0), curveRadius: 30, shadowColor: .lightGray, shadowRadius: 4.0, heightOffset: 0.0)
        
        
        
        //addCurvedNavigationBar(backgroundColor: .brown, curveRadius: 17.0, shadowColor: .lightGray, shadowRadius: 4.0, heightOffset: 0.0)
        //parentProfileImageView.layer.cornerRadius = self.parentProfileImageView.frame.height / 2
        
        //parentProfileImageView.layer.masksToBounds = true
        
        
        //circularImageView.layer.borderColor = UIColor(red: 187/255, green: 156/255, blue: 98/255, alpha: 1.0).cgColor
        
        circularImageView.layer.borderColor = UIColor.white.cgColor
        circularImageView.layer.borderWidth = 8
        
        circularImageView.addCurvedView(imageview: circularImageView ,backgroundColor: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0), curveRadius: 30, shadowColor: .black, shadowRadius: 4.0, heightOffset: 0.0)
        /*
        circularImageView.layer.borderWidth = 2
        circularImageView.layer.borderColor = UIColor.white.cgColor*/
        
        
        setupCollectionView()
        //infoCollectionView.reloadData()
        //infoCollectionView.setNeedsLayout()
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
        
        let actionButton = JJFloatingActionButton()
        actionButton.buttonColor = UIColor(red: 205/255, green: 175/255, blue: 116/255, alpha: 1.0)
        actionButton.addItem(title: "item 1", image: UIImage(named: "user_profile_brown")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            var tabbbar = self.tabBarController as! newTabbarController
            if tabbbar != nil {
                tabbbar.firstMenuButtonAction(sender: nil)
            }
            
            
        }
        
        actionButton.display(inViewController: self)

        
        getNews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupCollectionView() {
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        mainCollectionView.showsVerticalScrollIndicator = false
        
        
        mainCollectionView.register(UINib(nibName: "informativeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "informativeCollectionViewCell")
        mainCollectionView.setNeedsLayout()
        mainCollectionView.reloadData()
        
        /*
        infoCollectionView.delegate = self
        infoCollectionView.dataSource = self
        
        infoCollectionView.showsVerticalScrollIndicator = false
        
        infoCollectionView.register(UINib(nibName: "childNotificationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "notiCell")
        
        
        
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = infoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal  // .horizontal
        }
        infoCollectionView.isPagingEnabled = true
        infoCollectionView.reloadData()
        infoCollectionView.setNeedsLayout()
        
        */
        /*
        
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        
        servicesCollectionView.showsVerticalScrollIndicator = false
        
        servicesCollectionView.register(UINib(nibName: "ServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ServiceCollectionViewCell")
        servicesCollectionView.register(UINib(nibName: "informativeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "informativeCollectionViewCell")
        //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
        
        
        
        if let layout = servicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        //servicesCollectionView.isPagingEnabled = true
        servicesCollectionView.reloadData()
        servicesCollectionView.setNeedsLayout()*/
    }
    func getNews() {
        
        
        DispatchQueue.main.async {
                   
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                       
            //self.view.isUserInteractionEnabled = false
            
        }
        
        
        WebService.getNews { (json) in
            print(json)
            
            DispatchQueue.main.async {
                                  
                                   
                          
                guard Utilities().isInternetAvailable() == true else{
                           
             
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    return
                    
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
            }
            
            
            print(json)
            
            //guard let errorCode = json["ErrorCode"] as? Int else {return}
            //guard let message = json["Message"] as? String else {return}
            
            guard let data = json["visaDetails"] as? [[String:Any]] else {return}
            
            
            for d in data {
                
                let rItem = SAIFZONENews()
               
                rItem.NID = String(describing: d["NID"] ?? "" )
                rItem.News = String(describing: d["News"] ?? "" )
                rItem.NewsDetail = String(describing: d["NewsDetail"] ?? "" )
                rItem.NewsImage = String(describing: d["NewsImage"] ?? "" )
               
                
                
                self.newsItem.append(rItem)
                
            }
            
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
    }
    func getServices() {
        
    }
    @IBAction func allButtonAction(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAboutUs"
        {
            let dest = segue.destination as! aboutUsDetailsViewController
            dest.index = selectedIndex
            dest.newsItem = self.selectedNews
        }
    }
}
extension HomePageViewController: UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //MARK: - CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == mainCollectionView
        {
            return 3
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        
        if collectionView == mainCollectionView {
            // about us collection view + 4 info cells
            
            
            if section == 0{
                return 1
            }else if section == 1{
                return 1
            }else {
                return newsItem.count
            }
        }
        if collectionView == infoCollectionView {
            return 1
        }
        if collectionView == socialCollectionView {
            return 4
        }
        
        return 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cellIdentifier = "Cell"
        
        if collectionView == mainCollectionView {
            
            
            if indexPath.section == 0 {
                cellIdentifier = "infoCell"
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                
                
                self.infoCollectionView = cell.viewWithTag(1) as? UICollectionView
                
                infoCollectionView.delegate = self
                infoCollectionView.dataSource = self
                
                infoCollectionView.showsVerticalScrollIndicator = false
                
                infoCollectionView.register(UINib(nibName: "childNotificationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "notiCell")
                infoCollectionView.frame = CGRect(x: 0, y: 0, width: mainCollectionView.frame.width - 20, height: 170)
          
                
                
                //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
                
                
                
                if let layout = infoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal  // .horizontal
                }
                infoCollectionView.isPagingEnabled = true
                infoCollectionView.reloadData()
                infoCollectionView.setNeedsLayout()
                
          
                
                return cell
                
            }else if indexPath.section == 1{
                cellIdentifier = "infoCell"
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
                      
                      
                      self.socialCollectionView = cell.viewWithTag(1) as? UICollectionView
                      
                      socialCollectionView.delegate = self
                      socialCollectionView.dataSource = self
                      
                      socialCollectionView.showsVerticalScrollIndicator = false
                      
                      socialCollectionView.register(UINib(nibName: "socialCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "socialCollectionViewCell")
                      socialCollectionView.frame = CGRect(x: 0, y: 0, width: mainCollectionView.frame.width - 20, height: 100)
                
                      
                      
                      //notificationsCollectionView.register(UINib(nibName: "cn1", bundle: nil), forCellWithReuseIdentifier: "notiCell11")
                      
                      
                      
                      if let layout = socialCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                          layout.scrollDirection = .horizontal  // .horizontal
                      }
                      socialCollectionView.isPagingEnabled = true
                      socialCollectionView.reloadData()
                      socialCollectionView.setNeedsLayout()
                      
                
                      
                      return cell
            }else {
                cellIdentifier = "informativeCollectionViewCell"
                       
                       
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! informativeCollectionViewCell
                
                cell.layoutIfNeeded()
                
                return cell
            }
        }
        
        
        if collectionView == self.infoCollectionView  {
            
            cellIdentifier = "notiCell"
            
            
            let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! childNotificationCollectionViewCell
            
            
            /*
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "NEW WAY OF DOING BUSINESS"
                cell.detailsLabel.text = "At SAIF ZONE, we offer you the attractive tax-friendly benefits combined with complete ownership in a designated free zone at an unmatched strategic location. With every detail thoughtfully structured and robust service support, we provide plenty of opportunities to connect and collaborate so you can focus solely on growing your business."
            case 1:
                cell.titleLabel.text = "Chairman’s Message"
                cell.detailsLabel.text = "As the Middle East and Africa becomes an ever more lucrative destination for global businesses, the competition to secure that business becomes equally as fierce. Minimal costs and maximum efficiency play a large role but ultimately it is the delivery of the entire package which will See the strongest businesses thrive. At SAIF ZONE we believe that we not only provide that package for this region, we deliver a product which connects our partners to the rest of the world"
            case 2:
                cell.titleLabel.text = "Director’s Message"
                cell.detailsLabel.text = "As we enter the second quarter of 2019, I am proud to inform you that more than 8,000 companies from around 165 countries have currently established their presence at the Sharjah Airport International Free Zone (SAIF ZONE). This is a grand testimony to SAIF ZONE’s growing appeal as a business destination where SMEs and multi-nationals alike can utilise the benefits of our strategic location, modern infrastructure and customer focus-based service to expand and conduct their businesses with confidence"
            default:
                cell.titleLabel.text = ""
            }
 */
       
            
           /*
           
            let string = "\(AppConstants.WEB_SERVER_IMAGE_MOCD_URL)\(childItem.child_picture )"
            let url = URL(string: string)
            cell.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "profile") ?? UIImage())
           
            
            
            switch childItem.status {
            case .NEED_TEST:
                print("")
                cell.backgroundColor = AppConstants.GRAY_COLOR
                cell.titleLabel.text = "\(childItem.firstName)" + " need test".localize
                cell.detailsLabel.text = "Please ensure that your child" + " \(childItem.firstName)" + " helth is fine".localize
                
            case .FINE:
                cell.backgroundColor = AppConstants.GREEN_COLOR
                cell.titleLabel.text = "\(childItem.firstName)" + " is Perfect".localize
                cell.detailsLabel.text = "\(childItem.firstName)" + " helth is perfect".localize
            case .UN_HEALTH:
                cell.backgroundColor = .orange
                cell.titleLabel.text = "\(childItem.firstName)" + " Might Need Attention".localize
                cell.detailsLabel.text = "\(childItem.firstName)" + " child's health Might need attention . Keep checking his health ".localize
            case .DANGER:
                cell.backgroundColor = AppConstants.F_RED_COLOR
                cell.titleLabel.text = "\(childItem.firstName)" + " need attention".localize
                cell.detailsLabel.text = "\(childItem.firstName)" + " child's health need attention .visit your closest medical center to get a check-up ".localize
            
            }*/
            
            /*
            if indexPath.row == 0 {
                
                cell.backgroundColor = .orange
                cell.profileImageView.image = UIImage(named: "c1")
                cell.titleLabel.text = "Naya need more attention"
                cell.detailsLabel.text = "please follow naya objectives in order to check her health status "
            }else if indexPath.row == 1 {
                cell.backgroundColor = AppConstants.GREEN_COLOR
                cell.profileImageView.image = UIImage(named: "c2")
                
                cell.titleLabel.text = "Jad is Fine"
                cell.detailsLabel.text = "please keep jad health status updated by asking all remainig questions"
            }else if indexPath.row == 2 {
                cell.backgroundColor = AppConstants.F_RED_COLOR
                cell.profileImageView.image = UIImage(named: "c3")
                cell.titleLabel.text = "selen need to visit center to check her health"
                cell.detailsLabel.text = "please keep selen health status updated by asking all remainig questions"
            }*/
            
            //scell.backgroundColor = .red
            return cell
        }
        
        if collectionView == self.socialCollectionView  {
                   
                  
            cellIdentifier = "socialCollectionViewCell"
                   
                   
            
            let cell = socialCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! socialCollectionViewCell
                   
                   
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
                   
                   
            
            return cell
            
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "informativeCollectionViewCell" {
            let cell = cell as! informativeCollectionViewCell
            
            let item = newsItem[indexPath.row]
            cell.imageView.image = UIImage(named: "info1")
            let url = URL(string: "\(AppConstants.WEB_SERVER_SAIFZONE_TEST_DOWNLOADLINK)download.aspx?FileID=\(item.NewsImage)")
            cell.imageView.kf.setImage(with: url)
            cell.titleLabel.text = ""
                          
            cell.descLabel.text = item.News
            /*
            switch indexPath.row {
            case 0:
                cell.imageView.image = UIImage(named: "info1")
                cell.titleLabel.text = "SAIF offices"
                cell.descLabel.text = "SAIF ZONE offers a wide range of offices to cater to the nature of your business and its varying demands."
                
            case 1:
                cell.imageView.image = UIImage(named: "info2")
                cell.titleLabel.text = "Warehouses"
                cell.descLabel.text = "All our warehouses are purposefully built to fuel your business."
                
            case 2:
                cell.imageView.image = UIImage(named: "info3")
                cell.titleLabel.text = "Plot of land"
                cell.descLabel.text = "Choose from variety of available plots varying from 2,500 sqm and above for custom-build warehouses/ factories."
                
                
            case 3:
                cell.imageView.image = UIImage(named: "info4")
                cell.titleLabel.text = "Jewelry park"
                cell.descLabel.text = "A full-fledged and highly specialized jewelry manufacturing unit."
                
            default:
                print("default")
            }*/
        }
        if cell.reuseIdentifier == "socialCollectionViewCell" {
            let cell = cell as! socialCollectionViewCell
            
            
            switch indexPath.row {
            case 0:
                cell.imageView.image = UIImage(named: "linkedin")
                
            case 1:
                cell.imageView.image = UIImage(named: "facebook")
            
            case 2:
                cell.imageView.image = UIImage(named: "instagram-sketched")
            
            case 3:
                cell.imageView.image = UIImage(named: "twitter")
            default:
                print("")
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == infoCollectionView {
            //selectedIndex = indexPath.item
            //self.performSegue(withIdentifier: "toAboutUs", sender: self)
            
            if let url = URL(string: "https://www.saif-zone.com") {
                UIApplication.shared.open(url)
            }
        }else if collectionView == mainCollectionView {
            
            if indexPath.section == 1 {
                
                switch indexPath.row {
                case 0:
                    if let url = URL(string: "https://www.linkedin.com/company/saifzone") {
                        UIApplication.shared.open(url)
                    }
                case 1:
                    if let url = URL(string: "https://www.facebook.com/SAIFZA/") {
                                          
                        UIApplication.shared.open(url)
                        
                    }
                    
                    
                case 2:
                    if let url = URL(string: "https://www.instagram.com/saif_zone/?hl=en") {
                                          
                        UIApplication.shared.open(url)
                        
                    }
                    
                case 3:
                    if let url = URL(string: "https://twitter.com/saif_zone?lang=en") {
                                          
                        UIApplication.shared.open(url)
                        
                    }
                default:
                    print("")
                }
            }
            if indexPath.section == 2 {
                selectedNews = newsItem[indexPath.row]
                self.performSegue(withIdentifier: "toAboutUs", sender: self)
            }
        }
        if collectionView == socialCollectionView {
            switch indexPath.row {
            case 0:
                if let url = URL(string: "https://www.linkedin.com/company/saifzone") {
                    UIApplication.shared.open(url)
                }
            case 1:
                if let url = URL(string: "https://www.facebook.com/SAIFZA/") {
                                      
                    UIApplication.shared.open(url)
                    
                }
                
                
            case 2:
                if let url = URL(string: "https://www.instagram.com/saif_zone/?hl=en") {
                                      
                    UIApplication.shared.open(url)
                    
                }
                
            case 3:
                if let url = URL(string: "https://twitter.com/saif_zone?lang=en") {
                                      
                    UIApplication.shared.open(url)
                    
                }
            default:
                print("")
            }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.mainCollectionView  {
            
            
            if indexPath.section == 0 {
                return CGSize(width: mainCollectionView.frame.width - 10  , height: 170)
            }
            if indexPath.section == 1 {
                return CGSize(width: mainCollectionView.frame.width , height: 80)
            }
            return CGSize(width: (mainCollectionView.frame.width - 40) / 2, height: 300)
            
        }
        if collectionView == self.infoCollectionView  {
            
             return CGSize(width: infoCollectionView.frame.width - 15  , height: 135)
            
        }
        if collectionView == self.socialCollectionView  {
            
             return CGSize(width: (socialCollectionView.frame.width / 4) - 10  , height: 60)
            
        }
        
        
        return CGSize(width: 150, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == mainCollectionView {
          
            if section == 0 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }else if section == 1 {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        
        if collectionView == socialCollectionView {
        }
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == mainCollectionView {
            if section == 0{
                return 0
            }
            
            if section == 1{
                return 0
            }
            return 10
            
        }
        return 10.0
    }
    
    
    
}


