//
//  ViewController.swift
//  WCApi
//
//  Created by Aleksander Koko on 06/21/2016.
//  Copyright (c) 2016 Aleksander Koko. All rights reserved.
//

import UIKit
import WCApi

class ViewController: UIViewController, LoginHandlerProtocol{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var login: Login?
    
    @IBAction func login(sender: AnyObject) {
        if
            let emailString = self.email.text,
            let passwordString = self.password.text{
            self.login!.login(emailString, password: passwordString)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.login = Login(handler: self)
    }

}

extension ViewController{
    
    func loginSuccess(user: UserModel){
        print(user.username)
    }
    
    func loginError(error: ErrorMessageGeneral){
        print(error)
    }
    
    func loginError(error: LoginErrorFatal){
        print(error)
    }
    
    func loginError(error: LoginErrorsBadCredentials){
        print(error)
    }
    
    func loginError(error: LoginErrorNotExists){
        print(error)
    }
    
}

