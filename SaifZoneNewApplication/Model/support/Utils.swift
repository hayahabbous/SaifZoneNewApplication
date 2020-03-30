//
//  Utils.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/15/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import JGProgressHUD
class Utils: NSObject {
    
    /*
    class func handleParseError(_ error: NSError, inViewController viewController: UIViewController) {
        
        if (error.code ==  MOCD_ERROR.no_INTERNET_CONNECTION_1.rawValue || error.code == MOCD_ERROR.no_INTERNET_CONNECTION_2.rawValue || error.code ==  MOCD_ERROR.no_INTERNET_CONNECTION_4.rawValue || error.code ==  MOCD_ERROR.no_INTERNET_CONNECTION__1.rawValue || error.code ==  MOCD_ERROR.no_INTERNET_CONNECTION_100.rawValue || error.code ==  MOCD_ERROR.no_INTERNET_CONNECTION_124.rawValue) {
            self.showErrorMessage(NSLocalizedString("Please check your connection and try again", comment:""), withTitle: "", andInViewController: viewController)
        }
        else {
            
            if error.code ==  MOCD_ERROR.useremail_TAKEN.rawValue {
                self.showErrorMessage(NSLocalizedString("The email address you have entered is already registed", comment:""), withTitle: "", andInViewController: viewController)
            }
            
            if error.code == MOCD_ERROR.username_TAKEN.rawValue {
                self.showErrorMessage(NSLocalizedString("Someone already has that usernme , Try another", comment:""), withTitle: "", andInViewController: viewController)
            }
            
            if error.code == MOCD_ERROR.invlide_USERNAME_AND_PASSWORD.rawValue {
                self.showErrorMessage(NSLocalizedString("The username or password you entered is incorrect", comment:""), withTitle: "", andInViewController: viewController)
            }
            
            if error.code == MOCD_ERROR.no_EMAIL_FOUND.rawValue {
                self.showErrorMessage(NSLocalizedString("No user found with this email, please enter a valid email address", comment:""), withTitle: "", andInViewController: viewController)
            }
            
            if error.code == MOCD_ERROR.domin_ERROR.rawValue {
                self.showErrorMessage(NSLocalizedString("Error On Service Try Again Later.", comment:""), withTitle: "", andInViewController: viewController)
            }
            
            if error.code == MOCD_ERROR.invlide_EMAIL.rawValue {
                self.showErrorMessage(NSLocalizedString("Email address format is invalid.", comment:""), withTitle: "", andInViewController: viewController)
            }
            
        }
    }
    */
    class func noInternetConnectionErrorInViewController(_ viewController: UIViewController) {
        self.showErrorMessage(NSLocalizedString("Please check your connection and try again", comment:""), withTitle: "", andInViewController: viewController)
    }
    class func showErrorMessage(_ errorMessage: String, withTitle title: String, andInViewController viewController: UIViewController) {
        
        let messageTitle = title.count <= 0 ? "MOCD" : title
        
        let alertController: UIAlertController = UIAlertController(title: messageTitle, message: errorMessage, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title:NSLocalizedString("ok",comment:""), style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func showIndicator(hud: JGProgressHUD ,view: UIView) {
        
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        
    }
    class func dismissIndicator(hud: JGProgressHUD) {
        hud.dismiss()
    }
    
    static func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert ,viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        
        let action = UIAlertAction(title: "ok", style: .default) { (action) in
            //.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        viewController.present(alertController, animated: true) {
            
        }
    }
    
}
