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
    
    enum SignUpResults : String {
        case NeedCaptcha = "NeedCaptcha"
        case Fail = "FAIL"
        case Pass = "PASS"
    }
    
    public init(handler: SignUpHandlerProtocol){
        self.handler = handler
        self.getToken = GetToken()
        self.getToken.setHandler(self)
    }
    
    public func setToken(token: String){
        self.token = token
        self.makeNetworkCall()
    }
    
    public func getTokenFatalError(error: GetTokenErrorFatal){
        self.handler.signUpError(error)
    }
    
    public func signUp(username: String, password: String, email: String?, captchaId: String, captchaText: String?) -> Void {
        
        self.username = username
        self.password = password
        self.email = email
        self.captchaId = captchaId
        self.captchaText = captchaText
        
        if self.token != nil{
            self.makeNetworkCall()
        }else{
            do {
                try self.getToken.getToken(GetToken.TokenTypes.CreateUserToken)
            }catch{}
        }
        
    }
    
    internal func makeNetworkCall() -> Void{
        
        Alamofire.request(
            .POST,
            Config.apiUrl,
            parameters: [
                "action": "createaccount",
                "format": "json",
                "createreturnurl": "https://commons.wikimedia.org/",
                "username": self.username!,
                "password": self.password!,
                "retype": self.password!,
                "createtoken": self.token!,
                "captchaWord": self.captchaText!,
                "captchaId": self.captchaId!
            ]
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    print(JSON)
                    
                    if let result = JSON.objectForKey("createaccount")?.objectForKey("status") {
                        
                        let resultStr : String = result as! String
                        
                        switch (resultStr) {
                        case SignUpResults.Pass.rawValue:
                            self.handler.signUpSuccess()
                            break
                        case SignUpResults.Fail.rawValue:
                            if let message = JSON.objectForKey("createaccount")?.objectForKey("message;"){
                                self.handler.signUpError(SignUpErrorFatal(message: message as! String))
                            }else{
                                self.handler.signUpError(SignUpErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                            }
                            break
                        default:
                            self.handler.signUpError(SignUpErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                            break
                        }
                        
                    }else{
                        self.handler.signUpError(SignUpErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                    }
                    
                }else{
                    self.handler.signUpError(SignUpErrorFatal(message: GeneralErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }
        
    }
    
}

public protocol SignUpHandlerProtocol{
    
    func signUpSuccess()
    func signUpError(error: SignUpErrorFatal)
    func signUpError(error: GetTokenErrorFatal)
    
}