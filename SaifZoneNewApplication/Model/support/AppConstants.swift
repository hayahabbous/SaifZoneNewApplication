//
//  AppConstants.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/9/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation

class AppConstants: NSObject {
    
    
    
    static let LIVE = false
    static let WEB_BASIC_URL_TEST_GENERATE_TOKEN = LIVE ? "https://SMportal.saif-zone.com/" : "https://devdpa.saif-zone.com/"
    static let WEB_BASIC_URL_TEST_CONSUME_TOKEN = LIVE ? "https://BMportal.saif-zone.com/" :"https://devdpm.saif-zone.com/"
    
    
    static let WEB_BASIC_URL_TEST_BASE_URL = LIVE ? "https://BMportal.saif-zone.com" :"https://devdpm.saif-zone.com"
    static let WEB_BASIC_URL_LIVE_BASE_URL = LIVE ? "https://mportal.saif-zone.com" :"https://mportal.saif-zone.com"
    
    
    static let WEB_BASIC_URL_LIVE_GENERATE_TOKEN = LIVE ? "https://mportal.saif-zone.com/" :"http://ws.saif-zone.com:7777/"
    static let WEB_BASIC_URL_LIVE_CONSUME_TOKEN = LIVE ? "https://mportal.saif-zone.com/" :"https://mportal.saif-zone.com/"
    
    
    static let WEB_SERVER_SAIFZONE_TEST = LIVE ? "https://SMportal.saif-zone.com/api/" :"https://devdpa.saif-zone.com/api/"
    
    
    static let WEB_SERVER_SAIFZONE_TEST_DOWNLOADLINK = LIVE ? "https://mportal.saif-zone.com/" :"https://devdp.saif-zone.com/"
    static let WEB_SERVER_SAIFZONE_LIVE_DOWNLOADLINK = LIVE ? "https://BMportal.saif-zone.com/" :"https://mportal.saif-zone.com/"
    
    static let WEB_SERVER_SAIFZONE_TEST_DOWNLOADLINK2 = LIVE ? "https://BMportal.saif-zone.com/" :"https://devdp.saif-zone.com/"
    
    static let WEB_SERVER_DOWNLOAD_LINK_FILE_TEST = LIVE ? "https://BMportal.saif-zone.com/download.aspx" :"https://devdpm.saif-zone.com/download.aspx"
    static let WEB_SERVER_DOWNLOAD_LINK_FILE_LIVE = LIVE ? "https://mportal.saif-zone.com/download.aspx" :"https://mportal.saif-zone.com/download.aspx"
    
    
    
    static let WEB_SERVER_DOWNLOAD_LICENSE_FILE = LIVE ? "https://mportal.saif-zone.com/tradelicense.aspx?LicenseNo=" :"https://devdp.saif-zone.com/tradelicense.aspx?LicenseNo="
    static let WEB_SERVER_DOWNLOAD_LICENSE_FILE_LIVE = LIVE ? "https://mportal.saif-zone.com/tradelicense.aspx?LicenseNo=" : "https://mportal.saif-zone.com/tradelicense.aspx?LicenseNo="
    
    
    
    static let WEB_SERVER_SAIFZONE_LIVE = ""
    static let APPLE_LANGUAGE_KEY = "AppleLanguages"
    static var DToken = "6RGT36D10Q637059759964359851B1I1"
    static var DOMAINURL = "http://mocdservices.dcxportal.com/api/"
    static var ImageURL = "http://mocdservices.dcxportal.com"
    static var purpleColor = UIColor(red: 55/256, green: 30/256, blue: 52/256, alpha: 1.0)
    
    
    static var CompanyCode = ""
    
    static let SAIFZONEUserData = "SAIFZONEUserData"
    static let SAIFZONECompanyData = "SAIFZONECompanyData"
    
    
    static var mainServicesArray: [SAIFZONEMainService] = []
    static var allServicesArray: [SAIFZONEService] = []
    static var isPushedFromLeft: Bool = false
    static var verificationCode: String = ""
    
    static var badgeCount = 0
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
