//
//  SAIFZONEMainService.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/19/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit

class SAIFZONEMainService: NSObject {
    
    var SCID: String = ""
    var Caption: String = ""
    var relatedServicesArray: [SAIFZONEService] = []
}


class SAIFZONEService: NSObject {
    var SID: String  = ""
    var Caption: String  = ""
    var ApplicationID: String  = ""
    var Description: String  = ""
    var Price: String  = ""
    var UrgentPrice: String  = ""
    
    var URL1: String  = ""
    var URL2: String  = ""
    
    
    var Duration: String  = ""
    var Category: String  = ""
    var Sequence: String  = ""
    var RequiredDocuments: String  = ""
    
    var WFRecordID: String  = ""
    var Parent: String  = ""
    var SubLevel: String  = ""

    
    var relatedServicesArray: [SAIFZONEService] = []
}
