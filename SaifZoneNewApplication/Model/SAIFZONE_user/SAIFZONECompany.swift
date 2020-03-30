//
//  SAIFZONECompany.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/23/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit


class SAIFZONECompany: NSObject {
    var Company_ID: String = ""
    var Company_Name:String  = ""
    
    var Company_Name_Ar:String  = ""
    
    var Incorporation_Date:String  = ""
    var sms_mobile_no:String  = ""
    var intl_sms_mobile_no:String  = ""
    var P_O_Box:String  = ""
    var LICENSE_NO:String  = ""
    var Owner_Name:String  = ""
    var Owner_Name_Ar:String  = ""
    
    
    var passport_no:String  = ""
    var nationality:String  = ""
    var arabic_name:String  = ""
    
    override init() {
           
      
    }
      
    init(dict:[String:Any]) {
           
           
           var userdictionary = dict
           
           
           
        if (userdictionary["Company_ID"]) is NSNull {userdictionary["Company_ID"] = ""} else { }
           
           
        if (userdictionary["Company_Name"]) is NSNull {userdictionary["Company_Name"] = ""} else { }
        if (userdictionary["Company_Name_Ar"]) is NSNull {userdictionary["Company_Name_Ar"] = ""} else { }
        if (userdictionary["Incorporation_Date"]) is NSNull {userdictionary["Incorporation_Date"] = ""} else { }
        if (userdictionary["sms_mobile_no"]) is NSNull {userdictionary["sms_mobile_no"] = ""} else { }
        if (userdictionary["intl_sms_mobile_no"]) is NSNull {userdictionary["intl_sms_mobile_no"] = ""} else { }
        if (userdictionary["P_O_Box"]) is NSNull {userdictionary["P_O_Box"] = ""} else { }
        if (userdictionary["LICENSE_NO"]) is NSNull {userdictionary["LICENSE_NO"] = ""} else { }
        if (userdictionary["Owner_Name"]) is NSNull {userdictionary["Owner_Name"] = ""} else { }
        if (userdictionary["Owner_Name_Ar"]) is NSNull {userdictionary["Owner_Name_Ar"] = ""} else { }
        if (userdictionary["passport_no"]) is NSNull {userdictionary["passport_no"] = ""} else { }
        if (userdictionary["nationality"]) is NSNull {userdictionary["nationality"] = ""} else { }
        if (userdictionary["arabic_name"]) is NSNull {userdictionary["arabic_name"] = ""} else { }
     
 
        UserDefaults.standard.set(userdictionary, forKey: AppConstants.SAIFZONECompanyData)
           
           
           
           
           
          
           
      
    }
       
       
       
       
    static func getSAIFZONECompany()-> SAIFZONECompany?{
           
        guard let dicData:[String:Any] = UserDefaults.standard.object(forKey: AppConstants.SAIFZONECompanyData) as? [String:Any] else {
        
            return nil
           
        }
           
           
        let appUser:SAIFZONECompany = SAIFZONECompany()

        appUser.Company_ID = String(describing: dicData["Company_ID"] ?? "")
        appUser.Company_Name = String(describing: dicData["Company_Name"] ?? "")
        appUser.Company_Name_Ar = String(describing: dicData["Company_Name_Ar"] ?? "")
        appUser.Incorporation_Date = String(describing: dicData["Incorporation_Date"] ?? "")
        appUser.sms_mobile_no = String(describing: dicData["sms_mobile_no"] ?? "")
        appUser.intl_sms_mobile_no = String(describing: dicData["intl_sms_mobile_no"] ?? "")
        appUser.P_O_Box = String(describing: dicData["P_O_Box"] ?? "")
        appUser.LICENSE_NO = String(describing: dicData["LICENSE_NO"] ?? "")
        appUser.Owner_Name = String(describing: dicData["Owner_Name"] ?? "")
        appUser.Owner_Name_Ar = String(describing: dicData["Owner_Name_Ar"] ?? "")
        appUser.passport_no = String(describing: dicData["passport_no"] ?? "")
        appUser.nationality = String(describing: dicData["nationality"] ?? "")
        appUser.nationality = String(describing: dicData["nationality"] ?? "")
        appUser.arabic_name = String(describing: dicData["arabic_name"] ?? "")
          
        return appUser
       
    }
       
}



