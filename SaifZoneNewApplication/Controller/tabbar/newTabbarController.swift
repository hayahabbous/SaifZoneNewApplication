//
//  newTabbarController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 4/23/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit


class newTabbarController: UITabBarController ,UITabBarControllerDelegate {
    
    
    
    var eChannelArray: [[String:Any]] = [[:]]
    var paymentsArray: [SAIFZONEPaymentRequest] = []
    var documentsArray: [SAIFZONEDocuments] = []
     let user = SAIFZONEUser.getSAIFZONEUser()
    var globalItem: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 2
        globalItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
       // self.delegate = self
       setupLastButton()
        setupFirstButton()
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    /*
       if let tabBarItem = self.tabBar.items?[3] {
           tabBarItem.tag = 2
           
           let viewTabBar = tabBarItem.value(forKey: "view") as? UIView
           let imageView = viewTabBar?.subviews[0] as? UIImageView
           let label = viewTabBar?.subviews[1] as? UILabel
        label?.numberOfLines = 0
        label?.lineBreakMode = .byWordWrapping
        label?.textAlignment = .center
        //label?.textColor  = .black
        label?.sizeToFit()
        label?.frame = CGRect(x: label?.frame.maxX ?? 0  , y: label?.frame.maxY ?? 0 - 10, width: 60.0, height:  40.0)
       }*/
        if user?.DToken == nil {
            
            
            if let tabBarItem = self.tabBar.items?[2] {
                tabBarItem.tag = 2
                
                let viewTabBar = tabBarItem.value(forKey: "view") as? UIView
                let imageView = viewTabBar?.subviews[0] as? UIImageView
                let label = viewTabBar?.subviews[1] as? UILabel
                
                //label?.textColor = .green
            }
            if let tabBarItem = self.tabBar.items?[3] {
                tabBarItem.isEnabled = false
                
                
                var viewControllers = self.viewControllers
                viewControllers?.remove(at: 3)
                self.viewControllers = viewControllers
            }
            
            
            if let tabBarItem = self.tabBar.items?[1] {
                tabBarItem.isEnabled = false
                var viewControllers = self.viewControllers
                viewControllers?.remove(at: 1)
                self.viewControllers = viewControllers
            }
            
            
        }else{
            self.getRequiredFields()
        }
        
    }
    
    func setupLastButton() {
        
        let width = self.tabBar.frame.width / 5
        var newWidth: CGFloat
        if user?.DToken == nil {
            newWidth = self.view.frame.width / 3.0 + 10.0
        }else{
            newWidth = self.view.frame.width / 5.0 + 10.0
        }
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: newWidth, height: 80))
        
        menuButton.frame.origin.y = tabBar.bounds.height - menuButton.frame.height
        menuButton.frame.origin.x = tabBar.bounds.width - (newWidth)
        menuButton.backgroundColor = .clear
        
        
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(menuButton)
        
    }
    
    
    
    func setupFirstButton() {
        
        let width = self.tabBar.frame.width / 5
        var newWidth: CGFloat
        if user?.DToken == nil {
            newWidth = self.view.frame.width / 3.0 + 10.0
        }else{
            newWidth = self.view.frame.width / 5.0 + 10.0
        }
        
        var menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: newWidth, height: 80))
        
        
        menuButton.frame.origin.y = tabBar.bounds.height - menuButton.frame.height
        menuButton.frame.origin.x = tabBar.bounds.width - self.view.frame.width
        menuButton.backgroundColor = .clear
        
        
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            
            menuButton.frame.origin.y = tabBar.bounds.height - menuButton.frame.height
            menuButton.frame.origin.x = tabBar.bounds.width - self.view.frame.width
            menuButton.backgroundColor = .clear
        case .pad:
            menuButton.frame.origin.y = tabBar.bounds.height - menuButton.frame.height
            menuButton.frame.origin.x = 40
            menuButton.frame = CGRect(x: menuButton.frame.origin.x , y: menuButton.frame.origin.y, width: 165, height: 80)
            menuButton.backgroundColor = .clear
        default:
            print("")
        }
        menuButton.addTarget(self, action: #selector(firstMenuButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(menuButton)
        
    }
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame

        menuButton.backgroundColor = UIColor.clear
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)

        menuButton.setImage(UIImage(named: "newLogo"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        
        
        if user?.DToken == nil {
            firstMenuButtonAction(sender: sender)
            return
        }
        
        let ServicesPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServicesViewController2") as! ServicesViewController
        
        
        let viewController = UIApplication.shared.windows.first!.rootViewController as! newTabbarController
        
        
        
        let tb1 = viewController.tabBar
        let index = user?.DToken == nil ? globalItem.tag - 2 : globalItem.tag - 1
        if let tb = viewController.viewControllers?[index] as? UINavigationController {
            tb.pushViewController(ServicesPageVC, animated: true)
        }
        
        
        
        
    }
    
    @objc func firstMenuButtonAction(sender: UIButton?) {
        
        
        let ServicesPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPageViewController2") as! loginPageViewController
        
        
        let viewController = UIApplication.shared.windows.first!.rootViewController as! newTabbarController
        
        print("tag is\(globalItem.tag)")
        
        let tb1 = viewController.tabBar
        
        
        let index = user?.DToken == nil ? globalItem.tag - 2 : globalItem.tag - 1
        if let tb = viewController.viewControllers?[index] as? UINavigationController {
            tb.pushViewControllerFromLeft(controller: ServicesPageVC)
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       
        globalItem = item
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func getRequiredFields() {
        
        
       
        let stat = UserDefaults.standard.object(forKey: "companyCode") as? String  ?? ""
        WebService.getRequiredFields(company_code: stat) { (json) in
            
            print(json)
            
            DispatchQueue.main.async {
                       
                        
                guard Utilities().isInternetAvailable() == true else{
                
                    //Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    
                    return
                    
                }
                
              
                //guard let message  = json["Message"] as? String else {return}
                //guard let errorCode  = json["ErrorCode"] as? Int else {return}
                guard let data  = json["requiredDocumentsList"] as? [[String:Any]] else {return}
                
                
                guard let payments  = json["Payments"] as? [[String:Any]] else {return}
                guard let eChannelList  = json["eChannelList"] as? [[String:Any]] else {return}
                
                self.documentsArray = []
                self.paymentsArray = []
                self.eChannelArray = eChannelList

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
                    AppConstants.badgeCount = self.documentsArray.count + self.eChannelArray.count + self.paymentsArray.count
                    if let tabBarItem = self.tabBar.items?[3] {
                        // In this case we want to modify the badge number of the third tab:
                        
                        
                        if AppConstants.badgeCount > 0 {
                            tabBarItem.badgeValue = String(describing: AppConstants.badgeCount)
                        }
                        
                    }
                }
            }
        }
    }
    
}
extension UINavigationController{
    func pushViewControllerFromLeft(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerToLeft() {
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
}
