//
//  SAIFZONEUser.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/15/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation

class SAIFZONEUser: NSObject {
    
    
    var DToken: String?
    var firstName: String = ""
    var lastName: String = ""
    var emiratesId: String = ""
    var phone: String = ""
    
    
    var email: String = ""
    var username: String = ""
    var emirate: String = ""
    var address: String = ""
    var nationality: String = ""
    var gender: String = ""
    
    var userToken: String?
    var UserId: String?
    
    var isCenter: String?
    var DId: String?
    override init() {
        
    }
    init(dict:[String:Any]) {
        
        
        var userdictionary = dict
        
        
        
        if (userdictionary["Data"]) is NSNull {userdictionary["Data"] = ""} else { }
        
        /*
        if (userdictionary["UserId"]) is NSNull {userdictionary["UserId"] = ""} else { }
        if (userdictionary["UserFirstName"]) is NSNull {userdictionary["UserFirstName"] = ""} else { }
        if (userdictionary["UserLastName"]) is NSNull {userdictionary["UserLastName"] = ""} else { }
        if (userdictionary["UserIdentityNo"]) is NSNull { userdictionary["UserIdentityNo"] = ""} else { }
        
        if (userdictionary["UserPhone"]) is NSNull { userdictionary["UserPhone"] = ""} else { }
        if (userdictionary["UserEmail"]) is NSNull { userdictionary["UserEmail"] = ""} else { }
        if (userdictionary["UserMobile"]) is NSNull { userdictionary["UserMobile"] = ""} else { }
        
        
        //if (userdictionary["username"]) is NSNull {userdictionary["username"] = "" } else { }
        if (userdictionary["UserHomeEmirate"]) is NSNull {userdictionary["UserHomeEmirate"] = "Not Set" } else { }
        if (userdictionary["UserHomeAddress"]) is NSNull {userdictionary["UserHomeAddress"] = "Not Set" } else { }
        
        if (userdictionary["UserWorkEmirate"]) is NSNull {userdictionary["UserWorkEmirate"] = "Not Set" } else { }
        if (userdictionary["UserWorkAddress"]) is NSNull {userdictionary["UserWorkAddress"] = "Not Set" } else { }
        
        if (userdictionary["UserGender"]) is NSNull {userdictionary["UserGender"] = "Not Set" } else { }
        if (userdictionary["UserNationality"]) is NSNull {userdictionary["UserNationality"] = "Not Set" } else { }
        if (userdictionary["token"]) is NSNull {userdictionary["token"] = "Not Set" } else { }
        if (userdictionary["isCenter"]) is NSNull {userdictionary["isCenter"] = ""} else { }
        if (userdictionary["dID"]) is NSNull {userdictionary["dID"] = ""} else { }
        */
        
        UserDefaults.standard.set(userdictionary, forKey: AppConstants.SAIFZONEUserData)
        
        
        
        
        
       
        
    }
    
    
    
    static func getSAIFZONEUser()-> SAIFZONEUser?{
        guard let dicData:[String:Any] = UserDefaults.standard.object(forKey: AppConstants.SAIFZONEUserData) as? [String:Any] else {
            return nil
        }
        
        let appUser:SAIFZONEUser = SAIFZONEUser()

        appUser.DToken = String(describing: dicData["Data"] ?? "")
        
        /*
        appUser.firstName = String(describing: dicData["UserFirstName"] ?? "")
        appUser.lastName = String(describing: dicData["UserLastName"] ?? "")
        appUser.emiratesId = String(describing: dicData["UserIdentityNo"] ?? "") //this ession for guest user
        appUser.phone = String(describing: dicData["UserPhone"] ?? "")
        
        
        appUser.email = String(describing: dicData["UserEmail"] ?? "")
        
        
        
        //appUser.username = String(describing:dicData["username"] ?? "" )
        appUser.emirate =  String(describing:dicData["UserHomeEmirate"] ?? "")
        appUser.address =  String(describing:dicData["UserHomeAddress"] ?? "")
        appUser.gender =  String(describing:dicData["UserGender"] ?? "")
        appUser.nationality = String(describing: dicData["UserNationality"] ?? "")
        appUser.userToken =  String(describing:dicData["token"] ?? "")
        appUser.isCenter = String(describing:dicData["isCenter"] ?? "")
        appUser.UserId = String(describing:dicData["UserId"] ?? "")
        appUser.DId = String(describing:dicData["dID"] ?? "")
 
 */
        return appUser
    }
    
}
