//
//  SAIFZONEVisa.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 7/14/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation


class SAIFZONEVisa: NSObject {
    
    var approved_visa: String = ""
    var utilized_visa: String = ""
    var balance_visa_available: String = ""
    var immig_card_no: String = ""
    var Immig_issue_dt: String = ""
    var Immig_expiry_dt: String = ""
    var immig_card_status: String = ""
    var applied_emp_visa: String = ""
    var expired_emp_visa: String = ""
    var rv_to_be_stamped: String = ""
    var stamped_res_visa: String = ""
    var rv_expiring_30_days: String = ""
    var pending_app: String = ""
    var rejected_app: String = ""
    var cancellation_no_leave_dt: String = ""
    var out_country_cancellation: String = ""
    var total_cancellation: String = ""
    var transfer_in: String = ""
    var transfer_out: String = ""
    var internal_transfer_in: String = ""
    var internal_transfer_out: String = ""
    var non_sponsored: String = ""
    var pass_in: String = ""
    
    
    
    
    var pass_out: String = ""
    var pass_delay: String = ""
    var pass_exempted: String = ""
    var pass_out_w_deposit: String = ""
    var pass_expiry_60_days: String = ""
    var acc_code: String = ""
    var acc_name: String = ""
    var total_absconders: String = ""
    var absconders_per: String = ""
    var Company_ref_no: String = ""
    var COUNTRY_NAME: String = ""
    
}
class SAIFZONENotification: NSObject {
    
    var ID: String = ""
    var CreateDate: String = ""
    var NotificationTitle: String = ""
    var NotificationText: String = ""
    var IsRead: String = ""
   
}

class SAIFZONEPaymentRequest: NSObject {
    
    var ID: String = ""
    var PaymentCaption: String = ""
    var AmountValue: String = ""
    var Status: String = ""
   
}
