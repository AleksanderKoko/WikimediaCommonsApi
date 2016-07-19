import UIKit
import WCApi

class ResetPasswordViewController: UIViewController, ResetPasswordHandlerProtocol {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    var resetPassword: ResetPassword?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetPassword = ResetPassword(handler: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(sender: AnyObject) {
        
        if self.username.text! != ""{
            self.resetPassword?.resetViaUsername(self.username.text!)
        }else if self.email.text! != ""{
            self.resetPassword?.resetViaEmail(self.email.text!)
        }else{
            let errorAlert = UIAlertView(title: "Cmon", message: "Fill something out", delegate: nil, cancelButtonTitle: "Close")
            errorAlert.show()
        }
        
    }
    
    func resetPasswordSuccess(){
        let errorAlert = UIAlertView(title: "Successful", message: "Check your email bro", delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }
    
    func resetPasswordError(error: ResetPasswordErrorFatal){
        let errorAlert = UIAlertView(title: "FatalError", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }
    
    func resetPasswordError(error: ResetPasswordThrottle){
        let errorAlert = UIAlertView(title: "Throttle error", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }
    
    func resetPasswordError(error: ResetPasswordBadInfo){
        let errorAlert = UIAlertView(title: "Bad Info", message: error.message, delegate: nil, cancelButtonTitle: "Close")
        errorAlert.show()
    }

}