//
//  SignUpViewController.swift
//  WCApi
//
//  Created by Aleksander Koko on 7/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import WCApi
import MapleBacon

class SignUpViewController: UIViewController {
    
    var getCaptcha: GetCaptcha? = nil
    var singUp: SignUp? = nil
    var captchaId: String?
    var captchaUrl: String?
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordAgain: UITextField!
    @IBOutlet weak var captchaText: UITextField!
    
    @IBOutlet weak var captchaImage: UIImageView!
    
    @IBAction func createUser(sender: AnyObject) {
        self.singUp!.signUp(self.username.text!, password: self.password.text!, email: self.email.text!, captchaId: self.captchaId!, captchaText: self.captchaText.text)
    }
    
    @IBAction func reloadCaptcha(sender: AnyObject) {
        self.reloadCaptchaNetworking()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCaptcha = GetCaptcha(handler: self)
        self.singUp = SignUp(handler: self)
        self.getCaptcha?.getCaptcha()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadCaptchaNetworking(){
        self.getCaptcha?.getCaptcha()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignUpViewController: GetCaptchaHandlerProtocol{
    
    func success(captchaId: String, captchaUrl: String){
        if let imageURL = NSURL(string: captchaUrl) {
            self.captchaImage.setImageWithURL(imageURL)
            self.captchaId = captchaId
        }else{
            print("hahahha")
        }
    }
    
    func getCaptchaFatalError(error: GetCaptchaErrorFatal){
        let errorAlert = UIAlertView(title: "Fail", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }
    
}

extension SignUpViewController: SignUpHandlerProtocol{
    
    func signUpSuccess(){
        let errorAlert = UIAlertView(title: "Yay", message: "Check your email bro", delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
        
    }
    
    func signUpError(error: SignUpErrorFatal){
        let errorAlert = UIAlertView(title: "Fail", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
        self.reloadCaptchaNetworking()
    }
    
    func signUpError(error: GetTokenErrorFatal){
        let errorAlert = UIAlertView(title: "Fail", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
        self.reloadCaptchaNetworking()
    }
    
}
