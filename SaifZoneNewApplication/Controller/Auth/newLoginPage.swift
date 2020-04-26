//
//  loginPageViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 3/2/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView
class newloginPageViewController: UIViewController {
    
    
    @IBOutlet var changableView: UIView!
    var user: SAIFZONEUser?
    let dataSource : [String] = ["Investor","Employee"]
    let tokenSource : [String] = ["mportal","hr"]
    let urlSource : [String] = ["GetValue","GetStaffValue"]
    @IBOutlet var usernameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var passwordTextfield: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var loginWithUAEPassButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var userProfileView: UIView!
    @IBOutlet var tableView: UITableView!
    
    
     let myCustomView: loginView = .fromNib()
    var loadDelegate: loadTabbar!
    
    let activityData = ActivityData()
    var username: String!
    var password: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back(sender:)))
        newBackButton.tintColor = AppConstants.purpleColor
        self.navigationItem.rightBarButtonItem = newBackButton
        
        
        
        tableView.tableFooterView = UIView()
        
        userProfileView.layer.cornerRadius = userProfileView.frame.height / 2
        
        userProfileView.layer.masksToBounds = true
        
        userProfileView.layer.borderColor = UIColor(red: 187/255, green: 156/255, blue: 98/255, alpha: 1.0).cgColor
        
        
        userProfileView.layer.borderWidth = 5
        setupView()
        
        
        
        
        self.changableView.backgroundColor = .red
        self.myCustomView.frame = self.changableView.frame
        self.changableView.addSubview(self.myCustomView)
        
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        _ = navigationController?.popViewControllerToLeft()
    }
    func setupView(){
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.layer.masksToBounds = true
        
        
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor(red: 187/255, green: 156/255, blue: 98/255, alpha: 1.0).cgColor
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        registerButton.layer.masksToBounds = true
        
      loginWithUAEPassButton.layer.borderWidth = 1
        loginWithUAEPassButton.layer.borderColor = UIColor.lightGray.cgColor
        loginWithUAEPassButton.layer.cornerRadius = loginWithUAEPassButton.frame.height / 2
        loginWithUAEPassButton.layer.masksToBounds = true
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    
    func checkFields() -> Bool{

        username = usernameTextField.text ?? ""
        password = passwordTextfield.text ?? ""
        
        
        if username.count == 0 || username == "" {
            
            Utils.showAlertWith(title: "Missing info", message: "Please enter username ", viewController: self)
            return false
            
        }else if password.count == 0 || password == "" {
            Utils.showAlertWith(title: "Missing info", message: "Please enter password ", viewController: self)
            
            return false
        }
        
        return true
    }
    @IBAction func pressedView(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        if checkFields() {
            
            DispatchQueue.main.async {
                guard Utilities().isInternetAvailable() == true else{
                    Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                    return
                }
                 NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                //self.view.isUserInteractionEnabled = false
            }
            WebService.getDToken(username: username, password: password) { (json) in
                
                print(json)
                DispatchQueue.main.async {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    //self.view.isUserInteractionEnabled = false
                    
                    guard let errorCode = json["ErrorCode"] as? Int else {return}
                     
                    
                    if errorCode == 0 {
                        guard let data = json["Data"] as? String else {
                            
                            DispatchQueue.main.async {
                                Utils.showAlertWith(title: "Error", message: "Login faild", viewController: self)
                            }
                            return
                            
                            
                        }
                        if data == "" {
                            
                            DispatchQueue.main.async {
                                Utils.showAlertWith(title: "Error", message: "Login faild", viewController: self)
                            }
                            return
                        }
                        var _: SAIFZONEUser = SAIFZONEUser(dict: json)
                        
                        self.user = SAIFZONEUser.getSAIFZONEUser()
                        
                        
                        DispatchQueue.main.async {
                            self.SaveLoginInfo()
                         
                            self.loadDelegate.loadTabbar()
                        }
                        print(data)
                    }else {
                        guard let message = json["Message"] as? String else {return}
                        
                        DispatchQueue.main.async {
                            Utils.showAlertWith(title: "Error", message: message, viewController: self)
                        }
                    }
                    
                }
                
                
                
            }
        }
    }
    
    func SaveLoginInfo()
    {
        
        
        DispatchQueue.main.async {
            UserDefaults.standard.set(self.username, forKey: "userName")
            UserDefaults.standard.set(self.password, forKey: "password")
            UserDefaults.standard.set("true", forKey: "autoLogin")
            
            self.tryForLogin()
        }
    }
    func tryForLogin() {
        let defaults = UserDefaults.standard
        var name : String = "123/1"
        if let str : String = defaults.string(forKey: "deviceID")
        {
            name = str + "/1"
        }
        
        let originalString = UserDefaults.standard.object(forKey: "password")  as! String
        var escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(escapedString!)
        escapedString = escapedString?.replacingOccurrences(of: "%", with: "7m7m7m")
        escapedString = escapedString?.replacingOccurrences(of: "*", with: "8m8m8m")
        print(escapedString!)
        
        // let url : String = "http://dev.saif-zone.com/_vti_bin/SharePoint.WCFService.Sample/Services/SampleService.svc/Auth(" + txtUserName.text! + "," + txtPassword.text! + "," + name + ")"
        
        let url :String = "http://ws.saif-zone.com:7777/authenticate/\(urlSource[0])/\(UserDefaults.standard.object(forKey: "userName")  as! String)/\(escapedString!)/\(name)"
        // let url :String =  "http://ws.saif-zone.com:7777/authenticate/GetValue/" + txtUserName.text! + "/" + txtPassword.text! + "/" + name
        
        let loginUrl = URL(string: url)
        var getRequest = URLRequest(url: loginUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        getRequest.httpMethod = "GET"
        getRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        getRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: getRequest, completionHandler: { (data, response, error) in
            do
                
            {
                guard data != nil else{
                    return
                }
                
                let jsonResult :NSDictionary! = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if (jsonResult != nil) {
                    // process jsonResult
                    
                    if jsonResult!.value(forKey: "AuthResult")  as! String != "NOTAUTHORIZED"
                    {
                        DispatchQueue.main.async(execute: {
                            
                            // vc.Url = "http://dev.saif-zone.com/en/m/Pages/ConsumeToken.aspx?TokenID=" + (jsonResult!.valueForKey("AuthResult")  as! String)
                            // UserDefaults.standard.set("http://devdpm.saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String), forKey: "URL")
                            
                            //                            self.Url = "http://devdpm.saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String)
                            // self.MainFunc()
                           
                            
                            UserDefaults.standard.set(jsonResult!.value(forKey: "AuthResult") , forKey: "loginToken")
                            //UserDefaults.standard.set("http://\(self.tokenSource[0]).saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String),forKey: "URL")
                            /*
                            let url = UserDefaults.standard.value(forKey: "URL")
                            if let root = UIApplication.shared.windows[0].rootViewController as? SFTabbarController {
                              
                                root.webVC.getData()
                            }
                           
                            */
                            //self.getData()
                            
                        })
                        
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: {
                            //self.gotoLoginPage()
                        })
                        
                    }
                } else {
                    DispatchQueue.main.async(execute: {
                        //self.gotoLoginPage()
                    })                    // couldn't load JSON, look at error
                }
                
            }
            catch
            {
                DispatchQueue.main.async(execute: {
                    //self.gotoLoginPage()
                })
            }
        }).resume()
        
        
    }
    
    
}

extension newloginPageViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "Cell" {
            let imageView = cell.viewWithTag(1) as! UIImageView
            let descLabel = cell.viewWithTag(2) as! UILabel
            
            switch indexPath.row {
            case 0:
                imageView.image = UIImage(named: "logoSolo")
                descLabel.text = "About Us"
            case 1:
                imageView.image = UIImage(named: "user_profile")
                descLabel.text = "Profile"
            case 2:
                imageView.image = UIImage(named: "license")
                descLabel.text = "License Details"
            case 3:
                imageView.image = UIImage(named: "pen")
                descLabel.text = "Statment of Account"
            case 4:
                imageView.image = UIImage(named: "screen")
                descLabel.text = "E-Services"
            case 5:
                imageView.image = UIImage(named: "visa")
                descLabel.text = "Visa Status"
            case 6:
                imageView.image = UIImage(named: "request")
                descLabel.text = "Request"
            case 7:
                imageView.image = UIImage(named: "settings")
                descLabel.text = "Settings"
            case 8:
                imageView.image = UIImage(named: "cancel")
                descLabel.text = ""
            default:
                print("")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
}
