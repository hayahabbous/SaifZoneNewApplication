//
//  profileViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/18/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


class profileViewController: UIViewController {
    
    
    var user: SAIFZONEUser?
    


    
    @IBOutlet var userProfileView: UIView!
    @IBOutlet var tableView: UITableView!
    
    let activityData = ActivityData()
    
    var loadDelegate: loadTabbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        userProfileView.layer.cornerRadius = userProfileView.frame.height / 2
        
        userProfileView.layer.masksToBounds = true
        
        userProfileView.layer.borderColor = UIColor(red: 187/255, green: 156/255, blue: 98/255, alpha: 1.0).cgColor
        
        
        userProfileView.layer.borderWidth = 5
        setupView()
        
        
        
        
    }
    
    
    func setupView(){
   
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
   
    @IBAction func pressedView(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    func logout() {
        
        
        
        let logOutAlertActionController = UIAlertController(title:"", message: NSLocalizedString("Are you sure you want to signout ?", comment:""), preferredStyle: .alert )
               
               
        let yesAlerActionOption = UIAlertAction(title:NSLocalizedString("Sure",comment:""), style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
              
            
            UserDefaults.standard.set(nil, forKey: AppConstants.SAIFZONEUserData)
            self.loadDelegate.loadTabbar()
           
            
        })
        
        let noAlertActionOption = UIAlertAction(title:NSLocalizedString("No",comment:""), style: .default, handler: nil)
        
        logOutAlertActionController.addAction(yesAlerActionOption)
        logOutAlertActionController.addAction(noAlertActionOption)
        
        self.present(logOutAlertActionController, animated: true, completion: nil)
        
        
    }
    
}

extension profileViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "Cell" {
            let imageView = cell.viewWithTag(1) as! UIImageView
            let descLabel = cell.viewWithTag(2) as! UILabel
            
            
            imageView.image = UIImage(named: "license")
            descLabel.text = "License Details"
            switch indexPath.row {
                      case 0:
                       
                          imageView.image = UIImage(named: "license")
                          descLabel.text = "License Details"
                      case 1:
                          
                          imageView.image = UIImage(named: "cancel")
                          descLabel.text = "Logout"
                      default:
                          print("")
                      }
            /*
            switch indexPath.row {
            case 0:
                imageView.image = UIImage(named: "logoSolo")
                descLabel.text = "About Us"
            case 1:
                imageView.image = UIImage(named: "user_profile")
                descLabel.text = "Profile"
            case 2:
                imageView.image = UIImage(named: "license")
                descLabel.text = "License Details"
            case 3:
                imageView.image = UIImage(named: "pen")
                descLabel.text = "Statment of Account"
            case 4:
                imageView.image = UIImage(named: "screen")
                descLabel.text = "E-Services"
            case 5:
                imageView.image = UIImage(named: "visa")
                descLabel.text = "Visa Status"
            case 6:
                imageView.image = UIImage(named: "request")
                descLabel.text = "Request"
            case 7:
                imageView.image = UIImage(named: "settings")
                descLabel.text = "Settings"
            case 8:
                imageView.image = UIImage(named: "cancel")
                descLabel.text = "Logout"
            default:
                print("")
            }
 */
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if indexPath.row == 1 {
            logout()
        }else{
            self.performSegue(withIdentifier: "toLicense", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
}
