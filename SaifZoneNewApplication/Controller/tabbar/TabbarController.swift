//
//  TabbarController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/9/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation

import UIKit


class TabbarController: UITabBarController {
    
    var home_button : UIButton!
    var category_button : UIButton!
    var search_button : UIButton!
    var notification_button : UIButton!
    var user_button : UIButton!
    
    
    
    var HomePageVC: UINavigationController = UINavigationController()
    var CategoryPageVC: UINavigationController = UINavigationController()
    var SearchPageVC: UINavigationController = UINavigationController()
    var NotificationsPageVC: UIViewController = UIViewController()
    var UserPageVC: UINavigationController = UINavigationController()
    var MoreVC: UIViewController = UIViewController()
    var profileVC: UIViewController = UIViewController()
    
    
    
    var user: SAIFZONEUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbarBackgroundImage()
        
       
        setupButtons()
        
    }
    
    func setupTabbarBackgroundImage() {
        
        let imageUser = UIImage(named: "bg-nav")
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        let tabBarView = UIImageView(image: imageUser ?? UIImage())
        
        self.tabBar.addSubview(tabBarView)
        self.tabBar.sendSubviewToBack(tabBarView)
        
        tabBar.layer.borderColor = UIColor.white.cgColor
        tabBar.layer.borderWidth = 0
        tabBar.backgroundColor = UIColor(red: 248/255, green: 243/255, blue: 236/255, alpha: 1.0)
        
        
        
        if AppConstants.isIphoneXModel() {
            tabBarView.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width , height: self.tabBar.frame.height)
        }else{
            tabBarView.frame = CGRect(x: 0, y: -20, width: self.tabBar.frame.width , height: self.tabBar.frame.height)
        }
        
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
          
            appearance.backgroundColor = UIColor.clear
            tabBar.standardAppearance = appearance;
        } else {
            // Fallback on earlier versions
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
        
        
        
        home_button = UIButton(frame: CGRect(x: 0, y: self.tabBar.frame.origin.y, width: width, height: height))
        category_button = UIButton(frame: CGRect(x: width, y: self.tabBar.frame.origin.y, width: width, height: height))
        search_button = UIButton(frame: CGRect(x: width * 2, y: self.tabBar.frame.origin.y, width: width, height: height))
        notification_button = UIButton(frame: CGRect(x: width * 3, y: self.tabBar.frame.origin.y, width: width, height: height))
        user_button = UIButton(frame: CGRect(x: width * 4, y: self.tabBar.frame.origin.y, width: width, height: height))
        
        
        var homeMenuButtonFrame = home_button.frame
        homeMenuButtonFrame.origin.y = view.bounds.height - homeMenuButtonFrame.height
        homeMenuButtonFrame.origin.x = view.bounds.width - self.view.frame.width
        home_button.frame = homeMenuButtonFrame
        
        
        var categoryMenuButtonFrame = category_button.frame
        categoryMenuButtonFrame.origin.y = view.bounds.height - categoryMenuButtonFrame.height
        categoryMenuButtonFrame.origin.x = view.bounds.width - (width * 4 )
        category_button.frame = categoryMenuButtonFrame
    
        var searchMenuButtonFrame = search_button.frame
        if AppConstants.isIphoneXModel() {
            searchMenuButtonFrame.origin.y = view.bounds.height - searchMenuButtonFrame.height - self.tabBar.frame.height
        }else{
            searchMenuButtonFrame.origin.y = view.bounds.height - searchMenuButtonFrame.height - self.tabBar.frame.height + 10
        }
        
        searchMenuButtonFrame.origin.x = view.bounds.width - (width * 3 )
        search_button.frame = searchMenuButtonFrame
        
        
        var notificationsMenuButtonFrame = notification_button.frame
        notificationsMenuButtonFrame.origin.y = view.bounds.height - notificationsMenuButtonFrame.height
        notificationsMenuButtonFrame.origin.x = view.bounds.width - (width * 2 )
        notification_button.frame = notificationsMenuButtonFrame
    
        var userMenuButtonFrame = user_button.frame
        userMenuButtonFrame.origin.y = view.bounds.height - userMenuButtonFrame.height
        userMenuButtonFrame.origin.x = view.bounds.width - (width)
        user_button.frame = userMenuButtonFrame
        
        
        
        home_button.backgroundColor = UIColor.clear
        category_button.backgroundColor = UIColor.clear
        search_button.backgroundColor = UIColor.clear
        notification_button.backgroundColor = UIColor.clear
        user_button.backgroundColor = UIColor.clear
        
        
        view.addSubview(home_button)
        view.addSubview(category_button)
        view.addSubview(search_button)
        view.addSubview(notification_button)
        view.addSubview(user_button)
        
        
        setButtonImage()
        
     
        
        home_button.addTarget(self, action: #selector(homeButtonAction(sender:)), for: .touchUpInside)
        category_button.addTarget(self, action: #selector(categoryButtonAction(sender:)), for: .touchUpInside)
        search_button.addTarget(self, action: #selector(searchButtonAction(sender:)), for: .touchUpInside)
        notification_button.addTarget(self, action: #selector(notificationButtonAction(sender:)), for: .touchUpInside)
        user_button.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
        
    }
    
    
    func setButtonImage() {
        home_button.setImage(UIImage(named: "icons8-home2"), for: .selected)
        home_button.setImage(UIImage(named: "icons8-home1"), for: .normal)
        
        
        category_button.setImage(UIImage(named: "icons8-category2"), for: .selected)
        category_button.setImage(UIImage(named: "icons8-category1"), for: .normal)
        
        
        search_button.setImage(UIImage(named: "search-icon"), for: .selected)
        search_button.setImage(UIImage(named: "search-icon"), for: .normal)
        
        
        search_button.imageView?.layer.cornerRadius = search_button.frame.height / 2
        search_button.imageView?.layer.masksToBounds = true
        notification_button.setImage(UIImage(named: "icons8-notification2"), for: .selected)
        notification_button.setImage(UIImage(named: "icons8-notification1"), for: .normal)
        
        user_button.setImage(UIImage(named: "icons8-user2"), for: .selected)
        user_button.setImage(UIImage(named: "icons8-user1"), for: .normal)
        
        
        
        search_button.imageView?.contentMode = .scaleAspectFit
    }
    @objc private func homeButtonAction(sender: UIButton) {
           
        HomePageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageVC") as! UINavigationController
        viewControllers = [HomePageVC]
        selectedIndex = 0
           
        setButtonImage()
        home_button.setImage(UIImage(named: "icons8-home2"), for: .normal)
      
    }
    
    @objc private func categoryButtonAction(sender: UIButton) {
           
        CategoryPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesViewController") as! UINavigationController
        viewControllers = [CategoryPageVC]
        selectedIndex = 1
           
        setButtonImage()
        category_button.setImage(UIImage(named: "icons8-category2"), for: .normal)
      
    }
    
    @objc private func searchButtonAction(sender: UIButton) {
           
        //SearchPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "exploreViewController") as! UINavigationController
        SearchPageVC = UIStoryboard(name: "SimpleViewController", bundle: nil).instantiateViewController(withIdentifier: "SimpleViewController") as! UINavigationController
        viewControllers = [SearchPageVC]
        selectedIndex = 2
           
        setButtonImage()
       
      
    }
    
    @objc private func notificationButtonAction(sender: UIButton) {
           
        NotificationsPageVC = UIStoryboard(name: "SimpleViewController", bundle: nil).instantiateViewController(withIdentifier: "SimpleViewController") as! UIViewController
        viewControllers = [NotificationsPageVC]
        selectedIndex = 3
           
        setButtonImage()
       
      
        
        
    }
    
    @objc private func profileButtonAction(sender: UIButton) {
           
        
        self.performSegue(withIdentifier: "toMoreList", sender: self.tabBarController)
        /*
        //SearchPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "exploreViewController") as! UINavigationController
        MoreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "moreViewController") as UIViewController
        viewControllers = [MoreVC]
        selectedIndex = 4
           */
        setButtonImage()
       
      
    }
}
