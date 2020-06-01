//
//  statmentHeaderView.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 5/14/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit


class statmentHeaderView: UITableViewCell ,WWCalendarTimeSelectorProtocol{
    
    
    var globalSender: UIButton!
    @IBOutlet var toButton: UIButton!
    @IBOutlet var fromButton: UIButton!
    
    
    
    var fromDateString: String?
    var fromDate: Date?
    
    var delegate: loadStatmentsForDates!
    var toDateString: String?
    var toDate: Date?
    
    
    var viewController: newStatmentOfAccountViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func showCalendar() {
          let selector = WWCalendarTimeSelector.instantiate()
          selector.delegate = self
          /*
           Any other options are to be set before presenting selector!
           */
          
          selector.optionStyles.showDateMonth(true)
          selector.optionStyles.showMonth(false)
          selector.optionStyles.showYear(true)
          selector.optionStyles.showTime(false)
          
         
        viewController.present(selector, animated: true, completion: nil)
      }
    
     
      func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
          
          let currdate = Date()
          if date > currdate {
              return false
          }
          
          return true
          
      }
      func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
          
          
          
        globalSender.setTitle(date.stringFromFormat("MM/dd/yyyy"), for: .normal)
        
        
        if globalSender == fromButton {
            self.fromDateString = date.stringFromFormat("MM/dd/yyyy")
            self.fromDate = date
            self.viewController.dateFromString = fromDateString
        }else{
            self.toDateString = date.stringFromFormat("MM/dd/yyyy")
            self.toDate = date
            
            self.viewController.dateToString = toDateString
           
        }
     
        
        if self.fromDateString == nil || self.toDateString == nil {
                       
            Utils.showAlertWith(title: "empty fields", message: "please fill fields to relod statments ", viewController: self.viewController)
            
            return
            
        }
         
        /*
        
         if fromDate ?? Date() > toDate ?? Date() {
                       
         
         Utils.showAlertWith(title: "Error", message: "from date is bigger than to date ", viewController: self.viewController)
         
         return
         
         }*/
         
        self.delegate.loadDates(fromDate: self.fromDateString ?? "", toDate: self.toDateString ?? "")
          
         
          /*
          let formatter = DateFormatter()
         
          formatter.dateFormat = "MM/dd/yyyy"
          formatter.locale = Locale(identifier: "en")

          let dateString = formatter.string(from: date)
          childItem.birthdate = dateString
          
          self.birthdate = dateString
          
          */
          let now = Date()
          let birthday: Date = date
          let calendar = Calendar.current
          
          let ageComponents = calendar.dateComponents([.year ,.month], from: birthday, to: now)
          let age = ageComponents.year!
          let ageMonth = ageComponents.month ?? 0
          
          //ageTextField.text = String(describing: "\(age) Years and \(ageMonth) Months ")
          
          print(date)
      }

    
    @IBAction func fromButtonAction(_ sender: Any) {
        
        self.globalSender = fromButton
        showCalendar()
        
    }
    @IBAction func toButtonAction(_ sender: Any) {
        
        self.globalSender = toButton
        showCalendar()
    }
}
