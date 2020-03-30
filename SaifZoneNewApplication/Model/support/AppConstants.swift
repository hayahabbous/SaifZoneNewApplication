//
//  AppConstants.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/9/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation

class AppConstants: NSObject {
    
    
    static let WEB_SERVER_SAIFZONE_TEST = "https://devdpa.saif-zone.com/api/"
    static let WEB_SERVER_SAIFZONE_LIVE = ""
    static let APPLE_LANGUAGE_KEY = "AppleLanguages"
    static var DToken = "6RGT36D10Q637059759964359851B1I1"
    static var DOMAINURL = "http://mocdservices.dcxportal.com/api/"
    static var ImageURL = "http://mocdservices.dcxportal.com"
    
    
    
    static let SAIFZONEUserData = "SAIFZONEUserData"
    static let SAIFZONECompanyData = "SAIFZONECompanyData"
    
    
    static var mainServicesArray: [SAIFZONEMainService] = []
    static var allServicesArray: [SAIFZONEService] = []
    
    static var verificationCode: String = ""
    static func isIphoneXModel() -> Bool {
        
        
        if UIDevice().userInterfaceIdiom == .phone &&
            UIScreen.main.nativeBounds.height == 2436 ||
            UIScreen.main.nativeBounds.height == 1792 ||
            UIScreen.main.nativeBounds.height == 2688{
            //iPhone X
            return true
        }else{
            return false
        }
        
        
        
    }
    
    
    static func isArabic() -> Bool {
        
        print("language is : \(NSLocale.preferredLanguages[0])")
        print("language in standard is : \(NSLocale.preferredLanguages[0])  ")
        return NSLocale.preferredLanguages[0].range(of:"ar") != nil
    }
}
