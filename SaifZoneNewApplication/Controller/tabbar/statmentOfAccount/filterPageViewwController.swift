//
//  filterPageViewwController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 4/27/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit


class filterPageViewwController: UIViewController ,WWCalendarTimeSelectorProtocol {
    
    
    @IBOutlet var fromButton: UIButton!
    @IBOutlet var toButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    
    @IBOutlet var fromTextField: UITextField!
    @IBOutlet var toTextField: UITextField!
    
    @IBOutlet var globalView: UIView!
    var globalSender: UITextField!
    var delegate: loadStatmentsForDates!
    
    
    var fromDateString: String?
    var fromDate: Date?
    
    
    var toDateString: String?
    var toDate: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.layer.cornerRadius = 5
        doneButton.layer.masksToBounds = true
        
        
        
        globalView.layer.cornerRadius = 5
        globalView.layer.masksToBounds = true
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
          
         
          present(selector, animated: true, completion: nil)
      }
    
     
      func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
          
          let currdate = Date()
          if date > currdate {
              return false
          }
          
          return true
          
      }
      func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
          
          
          
          globalSender.text = date.stringFromFormat("MM/dd/yyyy")
        
        
        if globalSender == fromTextField {
            self.fromDateString = date.stringFromFormat("MM/dd/yyyy")
            self.fromDate = date
        }else{
            self.toDateString = date.stringFromFormat("MM/dd/yyyy")
            self.toDate = date
        }
     
          
         
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

    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func fromButtonAction(_ sender: Any) {
        
        self.globalSender = fromTextField
        showCalendar()
        
    }
    @IBAction func toButtonAction(_ sender: Any) {
        
        self.globalSender = toTextField
        showCalendar()
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        
        
        
        
        if self.fromDateString == nil || self.toDateString == nil {
            Utils.showAlertWith(title: "empty fields", message: "please fill fields to relod statments ", viewController: self)
            return
        }
        
        if fromDate ?? Date() > toDate ?? Date() {
            
            Utils.showAlertWith(title: "Error", message: "from date is bigger than to date ", viewController: self)
            return
        }
        self.delegate.loadDates(fromDate: self.fromDateString ?? "", toDate: self.toDateString ?? "")
        self.dismiss(animated: true, completion: nil)
    }
}
