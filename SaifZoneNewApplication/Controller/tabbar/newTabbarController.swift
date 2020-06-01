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
    
    
    var globalItem: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 2
        globalItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
       // self.delegate = self
       setupLastButton()
        setupFirstButton()
    }
    
    
    func setupLastButton() {
        
        let width = self.tabBar.frame.width / 5
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        menuButton.frame.origin.y = tabBar.bounds.height - menuButton.frame.height
        menuButton.frame.origin.x = tabBar.bounds.width - (width)
        menuButton.backgroundColor = .clear
        
        
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        tabBar.addSubview(menuButton)
        
    }
    
    
    
    func setupFirstButton() {
        
        let width = self.tabBar.frame.width / 5
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 80))
        
        menuButton.frame.origin.y = tabBar.bounds.height - menuButton.frame.height
        menuButton.frame.origin.x = tabBar.bounds.width - self.view.frame.width
        menuButton.backgroundColor = .red
        
        
        
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

        menuButton.backgroundColor = UIColor.red
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)

        menuButton.setImage(UIImage(named: "newLogo"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        
        
        let ServicesPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServicesViewController2") as! ServicesViewController
        
        
        let viewController = UIApplication.shared.windows.first!.rootViewController as! newTabbarController
        
        
        
        let tb1 = viewController.tabBar
        if let tb = viewController.viewControllers?[globalItem.tag - 1] as? UINavigationController {
            tb.pushViewController(ServicesPageVC, animated: true)
        }
    }
    
    @objc private func firstMenuButtonAction(sender: UIButton) {
        
        
        let ServicesPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPageViewController2") as! loginPageViewController
        
        
        let viewController = UIApplication.shared.windows.first!.rootViewController as! newTabbarController
        
        
        
        let tb1 = viewController.tabBar
        if let tb = viewController.viewControllers?[globalItem.tag - 1] as? UINavigationController {
            tb.pushViewControllerFromLeft(controller: ServicesPageVC)
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       
        globalItem = item
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
}
extension UINavigationController{
    func pushViewControllerFromLeft(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
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
