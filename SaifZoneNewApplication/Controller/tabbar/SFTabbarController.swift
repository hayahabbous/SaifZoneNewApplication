//
//  SFTabbarController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/9/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit


protocol loadTabbar {
    func loadTabbar()
}
class SFTabbarController: UITabBarController , UIScrollViewDelegate , loadTabbar{
    func loadTabbar() {
        user = SAIFZONEUser.getSAIFZONEUser()
        setupIndex()
        
    }
    
    
    
    var services_button : UIButton!
    var notification_button : UIButton!
    var home_button : UIButton!
    var setting_button : UIButton!
    var info_button : UIButton!
    var tabbarDelegate: loadTabbar!
    
    
    var HomePageVC: UINavigationController = UINavigationController()
    var ServicesPageVC: UINavigationController = UINavigationController()
    var NotificationsPageVC: UINavigationController = UINavigationController()
    var SettingsPageVC: UINavigationController = UINavigationController()
    var InfoPageVC: UINavigationController = UINavigationController()
    var profileVC: UINavigationController = UINavigationController()
    var requestsVC: UINavigationController = UINavigationController()
    
    
    
    var webVC: webViewController = webViewController()
    
    var user:SAIFZONEUser?
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        setupButtons()
        user = SAIFZONEUser.getSAIFZONEUser()
        //setupIndex()
        loadHome()
        
        webVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webViewController") as! webViewController
        
    }
    func loadHome() {
        HomePageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as! UINavigationController
        viewControllers = [HomePageVC]
        selectedIndex = 2
           
    }
    func setupIndex() {
        
        
        
        
        
        if user?.DToken != nil {
            profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as! UINavigationController
            let profilePage = profileVC.viewControllers[0] as! profileViewController
            
            profilePage.loadDelegate = self
            viewControllers = [profileVC]
            selectedIndex = 4
        }else{
            InfoPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPageViewController") as! UINavigationController
            let loginpage = InfoPageVC.viewControllers[0] as! loginPageViewController
            
            loginpage.loadDelegate = self
            viewControllers = [InfoPageVC]
            selectedIndex = 4
        }
    }
    
    func setupButtons() {
        
        let width = self.view.frame.width / 5
        var height:CGFloat = 0.0
        
        
        
        if AppConstants.isIphoneXModel() {
            height = self.tabBar.frame.height + 39
        }else{
            height = self.tabBar.frame.height
        }
        
        
        
        services_button = UIButton(frame: CGRect(x: 0, y: self.tabBar.frame.origin.y, width: width, height: height))
        notification_button = UIButton(frame: CGRect(x: width, y: self.tabBar.frame.origin.y, width: width, height: height))
        home_button = UIButton(frame: CGRect(x: width * 2, y: self.tabBar.frame.origin.y, width: width, height: width))
        setting_button = UIButton(frame: CGRect(x: width * 3, y: self.tabBar.frame.origin.y, width: width, height: height))
        info_button = UIButton(frame: CGRect(x: width * 4, y: self.tabBar.frame.origin.y, width: width, height: height))
        
        
        var servicesMenuButtonFrame = services_button.frame
        servicesMenuButtonFrame.origin.y = view.bounds.height - servicesMenuButtonFrame.height
        servicesMenuButtonFrame.origin.x = view.bounds.width - self.view.frame.width
        services_button.frame = servicesMenuButtonFrame
        
        
        var notificationMenuButtonFrame = notification_button.frame
        notificationMenuButtonFrame.origin.y = view.bounds.height - notificationMenuButtonFrame.height
        notificationMenuButtonFrame.origin.x = view.bounds.width - (width * 4 )
        notification_button.frame = notificationMenuButtonFrame
    
        var homeMenuButtonFrame = home_button.frame
        if AppConstants.isIphoneXModel() {
            homeMenuButtonFrame.origin.y = view.bounds.height - homeMenuButtonFrame.height - (self.tabBar.frame.height / 2)
        }else{
            homeMenuButtonFrame.origin.y = view.bounds.height - homeMenuButtonFrame.height - (self.tabBar.frame.height / 2 ) + 15
        }
        
        homeMenuButtonFrame.origin.x = view.bounds.width - (width * 3 )
        home_button.frame = homeMenuButtonFrame
        
        
        var settingsMenuButtonFrame = setting_button.frame
        settingsMenuButtonFrame.origin.y = view.bounds.height - settingsMenuButtonFrame.height
        settingsMenuButtonFrame.origin.x = view.bounds.width - (width * 2 )
        setting_button.frame = settingsMenuButtonFrame
    
        var infoMenuButtonFrame = info_button.frame
        infoMenuButtonFrame.origin.y = view.bounds.height - infoMenuButtonFrame.height
        infoMenuButtonFrame.origin.x = view.bounds.width - (width)
        info_button.frame = infoMenuButtonFrame
        
        
        
        services_button.backgroundColor = UIColor.clear
        notification_button.backgroundColor = UIColor.clear
        home_button.backgroundColor = UIColor.lightGray//UIColor(red: 187/255, green: 156/255, blue: 98/255, alpha: 1.0) //UIColor.clear
        setting_button.backgroundColor = UIColor.clear
        info_button.backgroundColor = UIColor.clear
        
        
        view.insertSubview(services_button, aboveSubview: self.tabBar)
        view.insertSubview(notification_button, aboveSubview: self.tabBar)
        view.insertSubview(home_button, aboveSubview: self.tabBar)
        view.insertSubview(setting_button, aboveSubview: self.tabBar)
        view.insertSubview(info_button, aboveSubview: self.tabBar)
        
        
        setButtonImage()
        
     
        
        home_button.addTarget(self, action: #selector(homeButtonAction(sender:)), for: .touchUpInside)
        
        services_button.addTarget(self, action: #selector(ServicseButtonAction(sender:)), for: .touchUpInside)
        notification_button.addTarget(self, action: #selector(NotificationsButtonAction(sender:)), for: .touchUpInside)
        setting_button.addTarget(self, action: #selector(SettingsButtonAction(sender:)), for: .touchUpInside)
        info_button.addTarget(self, action: #selector(pushServices), for: .touchUpInside)
        
    }
    
    func setButtonImage() {
        services_button.setImage(UIImage(named: "menu"), for: .selected)
        services_button.setImage(UIImage(named: "menu"), for: .normal)
        
        
        notification_button.setImage(UIImage(named: "request-2"), for: .selected)
        notification_button.setImage(UIImage(named: "request-2"), for: .normal)
        
        
        home_button.setImage(UIImage(named: "logoSolo"), for: .selected)
        home_button.setImage(UIImage(named: "logoSolo"), for: .normal)
        
        
        home_button.layer.cornerRadius = home_button.frame.height / 2
        home_button.layer.masksToBounds = true
        home_button.layer.borderColor = UIColor.white.cgColor
        home_button.layer.borderWidth = 10
        home_button.layer.shadowColor = UIColor.white.cgColor
        
        setting_button.setImage(UIImage(named: "financial-statement-2"), for: .selected)
        setting_button.setImage(UIImage(named: "financial-statement-2"), for: .normal)
        
        info_button.setImage(UIImage(named: "menu-7"), for: .selected)
        info_button.setImage(UIImage(named: "menu-7"), for: .normal)
        
        
        
        home_button.imageView?.contentMode = .scaleAspectFit
    }
    
    
    @objc private func homeButtonAction(sender: UIButton) {
        
        
        
        
        HomePageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageViewController") as! UINavigationController
        viewControllers = [HomePageVC]
        selectedIndex = 2
           
        setButtonImage()
        let scrollView = (HomePageVC.viewControllers[0] as! HomePageViewController ).scrollView
        scrollView?.delegate = self
        
        setButtonImage()
        home_button.setImage(UIImage(named: "logoSolo"), for: .normal)
      
        
    }
    
    @objc private func NotificationsButtonAction(sender: UIButton) {
           
        NotificationsPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! UINavigationController
        viewControllers = [NotificationsPageVC]
        selectedIndex = 1
           
        setButtonImage()
     
        notification_button.setImage(UIImage(named: "request-2"), for: .normal)
      
    }
    
    @objc private func ServicseButtonAction(sender: UIButton) {
           
        if user?.DToken != nil {
               profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileViewController") as! UINavigationController
               let profilePage = profileVC.viewControllers[0] as! profileViewController
               
               profilePage.loadDelegate = self
               viewControllers = [profileVC]
               selectedIndex = 4
           }else{
               InfoPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPageViewController") as! UINavigationController
               
               let loginpage = InfoPageVC.viewControllers[0] as! loginPageViewController
               
               loginpage.loadDelegate = self
               viewControllers = [InfoPageVC]
               selectedIndex = 4
           }

              
           setButtonImage()
        
           info_button.setImage(UIImage(named: "menu-7"), for: .normal)
       
      
    }
    @objc private func SettingsButtonAction(sender: UIButton) {
          
       
        SettingsPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "requestsViewController") as! UINavigationController
        viewControllers = [SettingsPageVC]
        selectedIndex = 3
           
        setButtonImage()
     
        setting_button.setImage(UIImage(named: "financial-statement-2"), for: .normal)
      
    }
    
    @objc private func InfoButtonAction(sender: UIButton) {
           
        
      ServicesPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServicesViewController") as! UINavigationController
             viewControllers = [ServicesPageVC]
             selectedIndex = 0
                
             setButtonImage()
          
             services_button.setImage(UIImage(named: "menu"), for: .normal)
    }
    
    
    
    @objc private func pushServices() {
         let ServicesPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServicesViewController2") as! ServicesViewController
        
        
        let viewController = UIApplication.shared.windows.first!.rootViewController as! SFTabbarController
        
        
        
        let tb1 = viewController.tabBar
        if let tb = viewController.viewControllers?[0] as? UINavigationController {
            tb.pushViewController(ServicesPageVC, animated: true)
        }
        
        
        
        

    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            changeTabBar(hidden: true, animated: true)
        }
        else{
            changeTabBar(hidden: false, animated: true)
        }
    }
    
    func changeTabBar(hidden:Bool, animated: Bool){
        guard let tabBar = self.tabBarController?.tabBar else { return; }
        if tabBar.isHidden == hidden{ return }
        let frame = tabBar.frame
        let offset = hidden ? frame.size.height : -frame.size.height
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        tabBar.isHidden = false

        UIView.animate(withDuration: duration, animations: {
            tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
        }, completion: { (true) in
            tabBar.isHidden = hidden
        })
    }
}
