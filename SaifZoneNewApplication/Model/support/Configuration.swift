//
//  Configuration.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/9/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit

struct Configuration {
    
    //StartSDK
    
    //live
    //static var paymentInfoURL = "http://ws.saif-zone.com:7777/authenticate/GetPaymentDetail/1/Asdf1234!@"
    static var paymentInfoURL = "http://devdpa.saif-zone.com/authenticate/GetPaymentDetail/1/Asdf1234!@"
    
    static var startSDKUrl = "https://api.start.payfort.com/tokens/"
    static let startSDKDevUrl = "https://api.start.payfort.com/tokens/"
    static let startSDKProductionUrl = "https://api.start.payfort.com/tokens/"
    
    
    // Payfort
    static var payfortUrl = "https://sbpaymentservices.payfort.com/FortAPI/paymentApi"
    static let payfortDevUrl = "https://sbpaymentservices.payfort.com/FortAPI/paymentApi"
    static let payfortProductionUrl = "https://paymentservices.payfort.com/FortAPI/paymentApi"
    
    static var requestPhrase = "xxxxxxxx"
    static var accessCode = "xxxxxxxx"
    static var merchantID = "xxxxxxxx"
    
    static let payfortDevPhrase = "asdsdgf"
    static let payfortDevAccessCode = "QeL6sGywtGeUx3VriMJ5"
    static let payfortDevMerchantID = "uhLlLCqr"
    
    static let payfortProductPhrase = "$2y$10$crwfR.9DS"
    static let payfortProductAccessCode = "qMoJX9iRFWhuPiUTdM4f"
    static let payfortProductMerchantID = "rCcPlKNh"
    
    static let authCommand = "AUTHORIZATION"
    static let purchaseCommand = "PURCHASE"
    static let sdkTokenCommand = "SDK_TOKEN"
    static let payfortCurreny = "SAR"
    static let payfortLanguage = "en"
    
    
    
    static func setPaymentUrl(transID: String) -> String {
        return "http://ws.saif-zone.com:7777/authenticate/GetPaymentDetail/\(transID)/Asdf1234!@"
        //return "http://devdpa.saif-zone.com/authenticate/GetPaymentDetail/\(transID)/Asdf1234!@"
    }
}

