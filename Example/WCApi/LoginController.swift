//
//  ViewController.swift
//  WCApi
//
//  Created by Aleksander Koko on 06/21/2016.
//  Copyright (c) 2016 Aleksander Koko. All rights reserved.
//

import UIKit
import WCApi

class LoginController: UIViewController, LoginHandlerProtocol, LogOutHandlerProtocol{

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    var login: Login?
    var logout: LogOut?
    
    @IBAction func login(sender: AnyObject) {
        if
            let emailString = self.username.text,
            let passwordString = self.password.text{
            self.login!.login(emailString, password: passwordString)
        }
    }
    
    @IBAction func logOut(sender: AnyObject) {
        self.logout?.logOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.login = Login(handler: self)
        self.logout = LogOut(handler: self)
    }

}

extension LoginController{
    
    func loginSuccess(user: UserModel){
        let errorAlert = UIAlertView(title: "Success", message: "Action was successfull. You username is \(user.username)", delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
        
        self.username.enabled = false
        self.password.enabled = false
        self.loginButton.enabled = false
        self.logoutButton.enabled = true
        self.uploadButton.enabled = true
        
        
    }
    
    func loginError(error: GetTokenErrorFatal){
        let errorAlert = UIAlertView(title: "Error", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }
    
    func loginError(error: LoginErrorFatal){
        let errorAlert = UIAlertView(title: "Error", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }
    
    func loginError(error: LoginErrorsBadCredentials){
        let errorAlert = UIAlertView(title: "Error", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
        self.password.text = ""
    }
    
    func loginError(error: LoginErrorNotExists){
        let errorAlert = UIAlertView(title: "Error", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }
    
}

extension LoginController{
    
    func logOutSuccess(){
        
        self.username.enabled = true
        self.password.enabled = true
        self.loginButton.enabled = true
        self.logoutButton.enabled = false
        self.uploadButton.enabled = false
        
        let errorAlert = UIAlertView(title: "Success", message: "Action was successfull. You are now out", delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
        
    }
    
    func logOutError(error: LogOutFatalError){
        let errorAlert = UIAlertView(title: "Error", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }
    
}

