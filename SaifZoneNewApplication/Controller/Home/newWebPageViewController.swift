//
//  newWebPageViewController.swift
//  SaifZoneNewApplication
//
//  Created by macbook pro on 5/16/20.
//  Copyright © 2020 Datacellme. All rights reserved.
//

import Foundation

import UIKit
import WebKit
import SystemConfiguration
import LocalAuthentication
import PassKit
import JGProgressHUD
import NVActivityIndicatorView




class newWebPageViewController : UIViewController, WKNavigationDelegate , openURLDelegate{
    func loadURL() {
        getData()
    }
    var selectedServiceURL: String?
  

    var hePay: Bool = false
    var delegate: loadTableDelegate!
    var transactionID: String = ""
    let hud = JGProgressHUD(style: .dark)
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var landingWebView: WKWebView!
    var isLoading : Bool = true
    var completedUrl : String = ""
    var startUrl : String = ""
    var mainServicesArray: [SAIFZONEMainService] = []
    var globalChargeAmount = "0"
     let activityData = ActivityData()
    var selectedMainService: SAIFZONEMainService = SAIFZONEMainService()
    //var popvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "progressPopUp") as! ProgressPopUp
    let payFort = PayFortController.init(enviroment: KPayFortEnviromentProduction)
    
    
    
    var webUrlString: String = ""
    
    // var Url : String = "http://mportal.saif-zone.com/"
    @IBAction func onBackClick(_ sender: Any) {
        //gotoLoginPage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(webViewController.touchStatusBar), name:NSNotification.Name(rawValue: "statusBarTappedNotification"), object: nil)
        landingWebView.navigationDelegate = self
        //uiView.isHidden = true
        //UserDefaults.standard.set("https://devdpm.saif-zone.com/Login.aspx", forKey: "URL")
        
        
        
        let user = SAIFZONEUser.getSAIFZONEUser()
        if user != nil {
            
            
            if UserDefaults.standard.value(forKey: "loginToken") != nil {
            }else{
                
            }
            
            UserDefaults.standard.set("\(AppConstants.WEB_BASIC_URL_TEST_CONSUME_TOKEN)/Default.aspx?TokenID=\(user?.DToken ?? "")" ,forKey: "URL")
        }else {
            UserDefaults.standard.set("\(AppConstants.WEB_BASIC_URL_TEST_BASE_URL)/default.aspx?pageid=75", forKey: "URL")
        }
        /*
        if UserDefaults.standard.value(forKey: "loginToken") != nil {
            
            
            UserDefaults.standard.set("\(AppConstants.WEB_BASIC_URL_TEST_CONSUME_TOKEN)/ConsumeToken.aspx?TokenID=" + (UserDefaults.standard.value(forKey: "loginToken")  as! String),forKey: "URL")
        }else{
            UserDefaults.standard.set("\(AppConstants.WEB_BASIC_URL_TEST_BASE_URL)/default.aspx?pageid=75", forKey: "URL")
            // createStatusBar()
            
        }
        */
        /*
        if selectedServiceURL != nil {
            UserDefaults.standard.set(selectedServiceURL, forKey: "URL")
        }else{
            UserDefaults.standard.set("https://mportal.saif-zone.com/default.aspx?pageid=75", forKey: "URL")
        }*/
    
        
        NotificationCenter.default.addObserver(self, selector: Selector(("reloadData:")), name: NSNotification.Name(rawValue: "reloadView"), object: nil)
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*
        if UserDefaults.standard.value(forKey: "loginToken") != nil {
            
            UserDefaults.standard.set("http://mportal.saif-zone.com/ConsumeToken.aspx?TokenID=" + (UserDefaults.standard.value(forKey: "loginToken")  as! String),forKey: "URL")
        }else{
            UserDefaults.standard.set("https://mportal.saif-zone.com/default.aspx?pageid=75", forKey: "URL")
            // createStatusBar()
            NotificationCenter.default.addObserver(self, selector: Selector(("reloadData:")), name: NSNotification.Name(rawValue: "reloadView"), object: nil)
        }*/
        
        print("loaded again")
    }
    @IBAction func payAction(_ sender: Any) {
        getPaymentInformation(transactionId: self.transactionID)
    }
    func reloadData(notification : NSNotification)
    {
        if notification.object != nil
        {
            if notification.object as! String != ""
            {
                UserDefaults.standard.set(notification.object as! String,forKey: "URL")
                print(notification.object ?? "")
            }
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        getData()
        
    }
    
    func getData() {
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : true,actionMessage : "Refresh", controller: self)
            return
        }
        let urlOther :String = UserDefaults.standard.object(forKey: "URL") as! String
        let url : URL = URL(string : urlOther)!
        let request1 = URLRequest(url: url)
        if landingWebView != nil {
            landingWebView.load(request1)
        }
        
        
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        
        decisionHandler(WKNavigationActionPolicy.allow)
        
        //self.payButton.isHidden = true
        let clickedUrl : String = (navigationAction.request.mainDocumentURL?.absoluteString)!
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Loading"
           // self.hud.show(in: self.view)
        }
        print("**CLICKED URL*\(clickedUrl)")
        startUrl = clickedUrl;
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : true,actionMessage : "Refresh", controller: self)
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        
        if clickedUrl.contains("Login.aspx") || clickedUrl == "\(AppConstants.WEB_BASIC_URL_TEST_BASE_URL)/login.aspx"
          
        {
            tryForLogin()
            /*
            decisionHandler(WKNavigationActionPolicy.cancel)
            let secure = UserDefaults.standard.object(forKey: "secure") ?? "false"
            let autoLogin = UserDefaults.standard.object(forKey: "autoLogin")  ?? "false"
            
            
            if secure as! String == "true" && autoLogin as! String == "true"{
                authenticationWithTouchID()
            }else if autoLogin as! String == "true"{
                tryForLogin()
            }else{
                gotoLoginPage()
            }
            return
  */
            //https://devdp.saif-zone.com/*/

        }
        /*
        if clickedUrl.contains("gis") {
            
            
            let mapViewController = UIStoryboard(name: "Main", bundle: Bundle(identifier: "com.saifzone.map")).instantiateInitialViewController()
            
            present(mapViewController!, animated: true, completion: nil)
        }
        if clickedUrl.contains("PageId=62") || clickedUrl.contains("PageId=30") || clickedUrl.contains("merchant_reference")
        {
           self.hud.show(in: self.view)
        }else if clickedUrl.contains("logout.aspx") {
            
        
            
           
            
            doOfflineLogout()
            
            //UserDefaults.standard.set("https://mportal.saif-zone.com", forKey: "URL")
            //UserDefaults.standard.set("https://devdpm.saif-zone.com/en/m/Pages/default.aspx", forKey: "URL")
            getData()
        }
        
        
        if clickedUrl.contains("Login.aspx") || clickedUrl == "https://mportal.saif-zone.com/login.aspx"
          
        {
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            let secure = UserDefaults.standard.object(forKey: "secure") ?? "false"
            let autoLogin = UserDefaults.standard.object(forKey: "autoLogin")  ?? "false"
            
            
            if secure as! String == "true" && autoLogin as! String == "true"{
                authenticationWithTouchID()
            }else if autoLogin as! String == "true"{
                tryForLogin()
            }else{
                gotoLoginPage()
            }
            return //https://devdp.saif-zone.com/
        }
        if(startUrl.contains("http://saif-zone.com/en/m/Pages/PDFViewer.aspx")){
            decisionHandler(WKNavigationActionPolicy.cancel)
            UIApplication.shared.open(URL(string : startUrl)!, options: [:], completionHandler: { (status) in
                
            })
            return
        }
        if(clickedUrl.contains("TokenID=") == true){
            //showProgress()
           // helper.showProgress("Loading...", view: self.view)
            
        }
        decisionHandler(WKNavigationActionPolicy.allow)
        
        */
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let clickedUrl : String = (webView.url?.absoluteString)!
        DispatchQueue.main.async {
            self.hud.dismiss()
           // self.payButton.isHidden = true
        }
        
        print("Finished navigating to url \(clickedUrl)");
        
        if clickedUrl.contains("Default.aspx?TokenID=")
        {
            //UserDefaults.standard.set(selectedServiceURL, forKey: "URL")
            //self.getData()
        }
        /*
        
        //self.payButton.isHidden = true
        print("Finished navigating to url \(clickedUrl)");
        
        if(clickedUrl.contains("pdf") || clickedUrl.contains("RegisterNewUser.aspx") || clickedUrl.contains("ForgotPassword.aspx")){
            //uiView.isHidden = false
            
        }else if clickedUrl.contains("PageId=62")
        {
          
            //self.payButton.isHidden = false
            //Utilities().showAlert(message: "you need to proceed with apple pay ?", isRefresh : false,actionMessage : "Refresh", controller: self)
            //let transactionString = clickedUrl.prefi
            
            if let range = clickedUrl.range(of: "ID=") {
                let transID = clickedUrl[range.upperBound...]
                self.transactionID = String(describing: transID)
                print(transactionID) // prints "123.456.7891"
            }

            getPaymentInformation(transactionId: self.transactionID)
            /*
            */
        }else if clickedUrl.contains("Login.aspx") || clickedUrl == "https://mportal.saif-zone.com/login.aspx"
           
        {
            
            //decisionHandler(WKNavigationActionPolicy.cancel)
            let secure = UserDefaults.standard.object(forKey: "secure") ?? "false"
            let autoLogin = UserDefaults.standard.object(forKey: "autoLogin")  ?? "false"
            
            
            if secure as! String == "true" && autoLogin as! String == "true"{
                authenticationWithTouchID()
            }else if autoLogin as! String == "true"{
                tryForLogin()
            }else{
                gotoLoginPage()
            }
            return //https://devdp.saif-zone.com/
        }else{
            //uiView.isHidden = true
            
        }
        if(clickedUrl.contains("TokenID=") == true){
       // helper.hideProgress(self.view)
        hideProgress()
        }
        */
    }
    
    func doOfflineLogout(){
        DispatchQueue.global(qos: .userInitiated).async {
            UserDefaults.standard.set("false", forKey: "secure")
            UserDefaults.standard.set("false", forKey: "autoLogin")
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "userType")
            UserDefaults.standard.removeObject(forKey: "tokenType")
        }
       
    }
    
    func appleFunction(amount: String , description: String) {
        DispatchQueue.main.async{
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.mportal.saifzone"
            request.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.countryCode = "AE"
            request.currencyCode = "AED"
       
            request.paymentSummaryItems = [
                PKPaymentSummaryItem(label: description, amount: NSDecimalNumber(string: amount))
            ]
            
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            applePayController?.delegate = self
            
            
            if PKPaymentAuthorizationViewController.canMakePayments() {
                NSLog("Can Make Payments");
            }
            else {
                NSLog("Can't Make Payments");
            }
            if(applePayController == nil){
                print("___")
            } else{
                self.present(applePayController!, animated: true, completion: nil)
            }
           
        }
        
    }
    
    
    
}


extension newWebPageViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    //TODO: User authenticated successfully, take appropriate action
                    self.tryForLogin()
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                      
                        return
                    }
                    print("**************"+self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    self.doOfflineLogout()
                    DispatchQueue.main.async(execute: {
                        self.gotoLoginPage()
                    })                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
            DispatchQueue.main.async(execute: {
                self.gotoLoginPage()
            })
        }
    }
    
    func gotoLoginPage(){
        
        /*
        let  story : UIStoryboard = UIStoryboard(name:"Main" , bundle: nil)
        let vc : vcLogin = story.instantiateViewController(withIdentifier: "Login") as! vcLogin
        vc.delegate = self
        vc.isModalInPopover = true
        
        self.dismiss(animated: true) {
            self.present(vc, animated: true) {
                
            }
        }*/
        
    }
    func tryForLogin() {
        
        var user = SAIFZONEUser.getSAIFZONEUser()
        if user != nil {
            UserDefaults.standard.set("\(AppConstants.WEB_BASIC_URL_TEST_CONSUME_TOKEN)ConsumeToken.aspx?TokenID=\(user?.DToken ?? "")&ReturnURL=\(AppConstants.WEB_BASIC_URL_TEST_BASE_URL)\(webUrlString)" ,forKey: "URL")
            
            self.getData()
        }
        
        
        
        
        DispatchQueue.main.async {
            guard Utilities().isInternetAvailable() == true else{
                Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
                return
            }
             NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
            //self.view.isUserInteractionEnabled = false
        }
        WebService.getDToken(username: UserDefaults.standard.object(forKey: "userName")  as? String ?? "", password: UserDefaults.standard.object(forKey: "password")  as? String ?? "") { (json) in
            
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
                    
                    var user = SAIFZONEUser.getSAIFZONEUser()
                    
                    
                    DispatchQueue.main.async {
                    
                        UserDefaults.standard.set(UserDefaults.standard.object(forKey: "userName")  as? String ?? "", forKey: "userName")
                        
                        UserDefaults.standard.set(UserDefaults.standard.object(forKey: "password")  as? String ?? "", forKey: "password")
                        
                        UserDefaults.standard.set("true", forKey: "autoLogin")
                         
                   
                        
                        UserDefaults.standard.set("\(AppConstants.WEB_BASIC_URL_TEST_CONSUME_TOKEN)ConsumeToken.aspx?TokenID=\(user?.DToken ?? "")&ReturnURL=\(AppConstants.WEB_BASIC_URL_TEST_BASE_URL)\(self.webUrlString)" ,forKey: "URL")
                        
                        self.getData()
                        
                        /*
                        if self.selectedServiceURL != nil {
                            UserDefaults.standard.set(self.selectedServiceURL,forKey: "URL")
                            self.getData()
                        }
                        */
                        //self.loadDelegate.loadTabbar()
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
        /*
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
        
        let url :String = "\(AppConstants.WEB_BASIC_URL_TEST_GENERATE_TOKEN)authenticate/GetValue/\(UserDefaults.standard.object(forKey: "userName")  as! String)/\(escapedString!)/\(name)"
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
                            UserDefaults.standard.set("\(AppConstants.WEB_BASIC_URL_TEST_CONSUME_TOKEN)ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String),forKey: "URL")
                            self.getData()
                            /*
                            
                            if self.selectedServiceURL != nil {
                                UserDefaults.standard.set(self.selectedServiceURL,forKey: "URL")
                                self.getData()
                            }*/
                            
                        })
                        
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: {
                            self.gotoLoginPage()
                        })
                        
                    }
                } else {
                    DispatchQueue.main.async(execute: {
                        self.gotoLoginPage()
                    })                    // couldn't load JSON, look at error
                }
                
            }
            catch
            {
                DispatchQueue.main.async(execute: {
                    self.gotoLoginPage()
                })
            }
        }).resume()
        
        */
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,with: event)
        self.touchStatusBar()
        
    }
    @objc func touchStatusBar()
    {
        //  dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //var top : CGPoint  = CGPointMake(0, -UIScreen.mainScreen().bounds.size.height+20)// can also use CGPointZero here
        
        //self.MyscrollView.setContentOffset(CGPointZero, animated:true)
        // self.wvSafeZone.scrollView.setContentOffset(CGPointMake(0 , -self.wvSafeZone.scrollView.contentInset.top), animated:true)
        //self.wvSafeZone.scrollView.setContentOffset(CGPointMake(0,  -UIApplication.sharedApplication().statusBarFrame.height ), animated: true)
        
        // self.wvSafeZone.scrollView.setContentOffset(CGPointMake(0, -self.wvSafeZone.scrollView.frame.height   + UIApplication.sharedApplication().statusBarFrame.height ), animated: true)
        // self.wvSafeZone.scrollView.setContentOffset(CGPointMake(0, 0 - self.wvSafeZone.scrollView.contentInset.top), animated: true)
        //self.wvSafeZone.scrollView.scrollsToTop = true
        // self.wvSafeZone.scrollView.contentOffset = CGPointMake(0, -100);
        //  ((UIScrollView*)[webView.subviews objectAtIndex:0]).scrollsToTop = YES;
        // self.wvSafeZone.reload()
        
        print("top")
        //    wvSafeZone.scrollView.scrollsToTop = true
        //wvSafeZone.subviews..setContentOffset(top, animated: true)
        // wvSafeZone.scrollView.setContentOffset(top, animated: true)
        
        //var script : NSString = "$('html, body').animate({scrollTop:0}, 'slow')"
        let script : NSString = "GotoTop();"
        //landingWebView.stringByEvaluatingJavaScript(from: script as String)
        //[webView stringByEvaluatingJavaScriptFromString:script];
        
        
        landingWebView.scrollView.scrollsToTop = true
        
    }
    
    
    func showProgress(){
        
        //self.addChildViewController(popvc)
        
        //popvc.view.frame = self.view.frame
        
        //self.view.addSubview(popvc.view)
        
        //popvc.didMove(toParentViewController: self)
    }
    
    func hideProgress(){
        //popvc.removeFromParentViewController()
        //popvc.didMove(toParentViewController: nil)
        //popvc.view.removeFromSuperview()

    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus)
        -> Void) {
        
        //Perform some very basic validation on the provided contact information
        let asyncSuccessful = payment.token.paymentData.count != 0
        
        if asyncSuccessful {
            
            let payFort = PayFortController.init(enviroment: KPayFortEnviromentProduction)
            let request = NSMutableDictionary.init()
            request.setValue("100100000", forKey: "amount")
            request.setValue("AUTHORIZATION", forKey: "command")
            request.setValue("USD", forKey: "currency")
            request.setValue("email@domain.com", forKey: "customer_email")
            request.setValue("en", forKey: "language")
            request.setValue("merchant", forKey: "merchant_reference")
            request.setValue("gr66zzwW9" , forKey: "sdk_token")
            request.setValue("APPLE_PAY" , forKey: "digital_wallet")
            
            payFort?.callPayFortForApplePay(withRequest: request,
                                        
                applePay: payment,
                currentViewController: self
                , success: { (requestDic, responeDic) in
                    print("success")
                    completion(.success)
                    
            }, faild:{ (requestDic, responeDic, message) in
                print("canceled")
                completion(.failure)
            })
        }else {
            completion(.failure)
        }
    }
    
    
    func getPaymentInformation(transactionId: String){
        
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view)
        
        let headers = [
            "Content-Type": "application/json"
        ]
        /*
        let parametersArray = [
            "RequestID": "1",
            "ValidationString": "Asdf1z234!@"
        ]
        
        let postdata: Data? = try? JSONSerialization.data(withJSONObject: parametersArray, options: [])*/
        let url = NSURL(string: Configuration.setPaymentUrl(transID: self.transactionID))! as URL
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        //request.httpBody = postdata
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (responseData, response, error) -> Void in
            DispatchQueue.main.async {
                self.hud.dismiss()
            }
            if (error != nil) {
                
                print(error?.localizedDescription as Any)
            } else {
                do {
                     let jsondata = try? JSON(data: responseData!)
                    
                    print(jsondata ?? "")
                    let jsonArray = jsondata?.array
                    
                    let ChargesAmount = String(jsonArray?[0]["TotalAmount"].int ?? 0)
                    self.globalChargeAmount = ChargesAmount
                    let PaymentDescription = jsonArray?[0]["PaymentDescription"].string ?? ""
                        
                    
                    self.appleFunction(amount: ChargesAmount, description: PaymentDescription)
                    
                    /*
                    let response_message:String = jsondata["response_message"].string!
                    if response_message == "Success" {
                        let sdkToken:String = jsondata["sdk_token"].string!
                        OperationQueue.main.addOperation {
                            self.connectPaymentGateway(token: sdkToken ,pk: pk)
                        }
                    }*/
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
            }
        })
        dataTask.resume()
    }
    func generateAccessToken(pk: PKPayment){
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        let newSDKToken = PayfortSdkToken()
        newSDKToken.access_code = Configuration.payfortProductAccessCode
        newSDKToken.device_id = UIDevice.current.identifierForVendor?.uuidString
        newSDKToken.language = Configuration.payfortLanguage
        newSDKToken.merchant_identifier = Configuration.payfortProductMerchantID
        newSDKToken.service_command = Configuration.sdkTokenCommand
        newSDKToken.signature = getSignatureStr(newSDKToken)
        
        let parameters = getSdkTokenParams(newSDKToken)
        
        let postdata: Data? = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: Configuration.payfortProductionUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postdata
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (responseData, response, error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription as Any)
            } else {
                do {
                    let jsondata = try JSON(data: responseData!)
                    print(jsondata)
                    let response_message:String = jsondata["response_message"].string!
                    if response_message == "Success" {
                        let sdkToken:String = jsondata["sdk_token"].string!
                        OperationQueue.main.addOperation {
                            self.connectPaymentGateway(token: sdkToken ,pk: pk)
                        }
                    }
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
            }
        })
        dataTask.resume()
    }
    
    func connectPaymentGateway(token:String ,pk: PKPayment){
        
        let currentTime = Int64(Date().timeIntervalSince1970 * 1000)
        let merchant_reference = "12586" + "_" + String(format: "%0.2d", currentTime)
        
        let request = NSMutableDictionary.init()
        
        let intAmount = (Int(self.globalChargeAmount) ?? 0 ) * 100
        let StringAmount = "\(intAmount)"
        
        
        request.setValue(StringAmount, forKey: "amount")
        //request.setValue("AUTHORIZATION", forKey: "command")
        request.setValue("PURCHASE", forKey: "command")
        request.setValue("AED", forKey: "currency")
        request.setValue("email@gmail.com", forKey: "customer_email")
        request.setValue("en", forKey: "language")
        request.setValue(merchant_reference, forKey: "merchant_reference")
        request.setValue(token , forKey: "sdk_token")
        //request.setValue("" , forKey: "payment_option")
        request.setValue("APPLE_PAY" , forKey: "digital_wallet")
        
        OperationQueue.main.addOperation {
            
            self.payFort?.callPayFortForApplePay(withRequest: request, applePay: pk, currentViewController: self, success: { (requestDic, responeDic) in
                
                print("success")
                print("responeDic=\(String(describing: responeDic))")
                
                
                let payResponse:PayfortResponse = self.getBookingByResponse(responeDic! as NSDictionary)
                print(payResponse)
                
                print(payResponse.response_message as Any)
                
                if payResponse.response_message == "Success"{
                    print("Payment Success")
                    let alert = UIAlertController(title: "Alert", message: "Payment Successful", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    //self.present(alert, animated: true, completion: nil)
                    
                    let urlOther :String = "\(AppConstants.WEB_BASIC_URL_TEST_BASE_URL)/default.aspx?pageid=60&response_message=Success&merchant_reference=\(self.transactionID)"
                    
                    //let urlOther :String = "https://devdpm.saif-zone.com/default.aspx?pageid=61"
                    let url : URL = URL(string : urlOther)!
                    let request1 = URLRequest(url: url)
                    self.hePay = false
                    self.landingWebView.load(request1)
                    
                    
                }
            }, faild: { (requestDic, responeDic, message) in
                print("faild")
                print("responeDic=\(String(describing: responeDic))")
                print("message=\(String(describing: message))")
                
                let alert = UIAlertController(title: "Alert", message: "Payment Failed", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            })
            
            /*
             self.payFort?.callPayFort(withRequest: request, currentViewController: self,
             success: { (requestDic, responeDic) in
             
             print("success")
             print("responeDic=\(String(describing: responeDic))")
             
             
             let payResponse:PayfortResponse = self.getBookingByResponse(responeDic! as NSDictionary)
             print(payResponse)
             
             print(payResponse.response_message as Any)
             
             if payResponse.response_message == "Success"{
             print("Payment Success")
             let alert = UIAlertController(title: "Alert", message: "Payment Successful", preferredStyle: UIAlertControllerStyle.alert)
             alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             }
             },canceled: { (requestDic, responeDic) in
             print("canceled")
             print("responeDic=\(String(describing: responeDic))")
             },faild: { (requestDic, responeDic, message) in
             print("faild")
             print("responeDic=\(String(describing: responeDic))")
             print("message=\(String(describing: message))")
             
             let alert = UIAlertController(title: "Alert", message: "Payment Failed", preferredStyle: UIAlertControllerStyle.alert)
             alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             })*/
        }
    }
    //Set Booking values by response data
    func getBookingByResponse(_ responseDic: NSDictionary) -> PayfortResponse{
        
        let responseData = PayfortResponse()
        
        responseData.fort_id = responseDic["fort_id"] as? String
        responseData.merchant_reference = responseDic["merchant_reference"] as? String
        responseData.expiry_date = responseDic["expiry_date"] as? String
        responseData.authorization_code = responseDic["authorization_code"] as? String
        responseData.token_name = responseDic["token_name"] as? String
        responseData.sdk_token = responseDic["sdk_token"] as? String
        responseData.customer_email = responseDic["customer_email"] as? String
        responseData.eci = responseDic["eci"] as? String
        responseData.payment_option = responseDic["payment_option"] as? String
        responseData.card_number = responseDic["card_number"] as? String
        responseData.customer_ip = responseDic["customer_ip"] as? String
        responseData.currency = responseDic["currency"] as? String
        responseData.amount = responseDic["amount"] as? String
        responseData.command = responseDic["command"] as? String
        responseData.response_message = responseDic["response_message"] as? String
        
        return responseData
        
    }
    
    
    func getSdkTokenParams(_ payfortToken: PayfortSdkToken) -> [String: AnyObject] {
        return [
            "service_command": (payfortToken.service_command == nil ? "" : payfortToken.service_command! ) as AnyObject,
            "access_code": (payfortToken.access_code == nil ? "" : payfortToken.access_code!) as AnyObject,
            "merchant_identifier": (payfortToken.merchant_identifier == nil ? "" : payfortToken.merchant_identifier!) as AnyObject,
            "language": (payfortToken.language == nil ? "" : payfortToken.language!) as AnyObject,
            "device_id": (payfortToken.device_id == nil ? "" : payfortToken.device_id!) as AnyObject,
            "signature": (payfortToken.signature == nil ? "" : payfortToken.signature!) as AnyObject,
            
        ]
    }
    
    func getSignatureStr(_ newToken: PayfortSdkToken) -> String {
        var signature = Configuration.payfortProductPhrase + "access_code=" + newToken.access_code! + "device_id=" + newToken.device_id! + "language=" + newToken.language!
        signature += "merchant_identifier=" + newToken.merchant_identifier! + "service_command=SDK_TOKEN" + Configuration.payfortProductPhrase
        return signature.sha256()
    }
    
    
    
  
}




extension newWebPageViewController:
PKPaymentAuthorizationViewControllerDelegate{
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        if !hePay {
            
            let urlOther :String = "\(AppConstants.WEB_BASIC_URL_TEST_BASE_URL)/default.aspx?PageId=30&tID=\(self.transactionID)"
            let url : URL = URL(string : urlOther)!
            let request1 = URLRequest(url: url)
            
            self.landingWebView.load(request1)
            
        }else{
            
        }
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        hePay = true
        if payment.token.paymentData.count != 0{
            self.generateAccessToken(pk: payment)
            completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: []))
        }else{
        hePay = false
            completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.failure, errors: []))
            
        }
        
        
    }
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        print("canceled")
    }
}
