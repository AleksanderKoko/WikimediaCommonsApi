import Alamofire

public class SignUp: GetTokenHandlerProtocol {
    
    internal let handler: SignUpHandlerProtocol
    internal let getToken: GetToken
    
    internal var token: String?
    internal var captchaId: String?
    
    internal var username: String?
    internal var password: String?
    internal var captchaText: String?
    internal var email: String?
    
    enum ErrorMessages: String {
        case FatalErrorCantProcessJSON
        case FatalErrorCantGetResponse
        case FatalErrorUnknownResultFromJSON
        case FatalErrorCantGetResultFromJSON
    }
    
    enum SignUpResults : String {
        case NeedCaptcha = "NeedCaptcha"
        case WrongPass = "WrongPass"
        case NoName = "NoName"
        case NotExists = "NotExists"
        case Success = "Success"
    }
    
    init(handler: SignUpHandlerProtocol){
        self.handler = handler
        self.getToken = GetToken()
        self.getToken.setHandler(self)
    }
    
    public func setToken(token: String){
        self.token = token
        self.makeNetworkCall()
    }
    
    public func getTokenFatalError(error: ErrorMessageGeneral){
        self.handler.signUpError(error)
    }
    
    func signUp(username: String, password: String, email: String?,captchaText: String?) -> Void {
        
        self.username = username
        self.password = password
        self.email = email
        self.captchaText = captchaText
        
        if self.token != nil{
            self.makeNetworkCall()
        }else{
            do {
                try self.getToken.getToken(TokenTypes.CreateUserToken)
            }catch{}
        }
        
    }
    
    internal func makeNetworkCall() -> Void{
        
        Alamofire.request(
            .POST,
            "https://en.wikipedia.org/w/api.php",
            parameters: [
                "action": "createaccount",
                "format": "json",
                "name": self.username!,
                "password": self.password!,
                "token": self.token!,
                "captchaword": self.captchaText!,
                "captchaid": self.captchaId!
            ]
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    print(JSON)
                    
                    if let result = JSON.objectForKey("createaccount")?.objectForKey("result") {
                        
                        let resultStr : String = result as! String
                        
                        switch (resultStr) {
                        case SignUpResults.NeedCaptcha.rawValue:
                            
                            if
                                let captchaUrl = JSON.objectForKey("createaccount")?.objectForKey("captcha")?.objectForKey("url")
                                
                            {
                                
                                if let captchaId = JSON.objectForKey("createaccount")?.objectForKey("captcha")?.objectForKey("id") {
                                    //let urlString = .baseUrl + (captchaUrl as! String)
                                    //let url = NSURL(string: urlString)
                                    //handler.wcSetCaptchaText(url!)
                                    //handler.wcSetCaptchaId(captchaId as! String);
                                }else{
                                    //handler.wcSignUpError(WCSignUpErrorFatal(message: ErrorMessages.FatalErrorCantProcessJSON.rawValue))
                                }
                                
                            }else{
                                //handler.wcSignUpError(WCSignUpErrorFatal(message: ErrorMessages.FatalErrorCantProcessJSON.rawValue))
                            }
                            
                            break
                        case    SignUpResults.NoName.rawValue:
                                //SignUpResults.EmptyPass.rawValue,
                                //SignUpErrorResults.WrongPass.rawValue:
                            //handler.wcLoginError(WCLoginErrorsBadCredentials())
                            break
                        //case LoginErrorResults.NotExists.rawValue:
                            //handler.wcLoginError(WCLoginErrorNotExists())
                        //    break
                        default:
                            //handler.wcLoginError(WCLoginErrorFatal(message: ErrorMessages.FatalErrorUnknownResultFromJSON.rawValue))
                            break
                        }
                        
                    }else{
                        //handler.wcLoginError(WCLoginErrorFatal(message: ErrorMessages.FatalErrorCantGetResultFromJSON.rawValue))
                    }
                    
                }else{
                    //handler.wcLoginError(WCLoginErrorFatal(message: ErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }
        
    }
    
}