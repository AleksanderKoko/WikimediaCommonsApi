import Alamofire

public class ResetPassword : GetTokenHandlerProtocol {
    
    internal let handler: ResetPasswordHandlerProtocol
    internal let getToken: GetToken
    
    internal var username: String?
    internal var email: String?
    internal var token: String?
    
    internal enum ResetPasswordResults : String {
        case Success = "success"
        case Failed = "throttled-mailpassword"
        case NotSuchUser = "nosuchuser"
    }
    
    public init(handler: ResetPasswordHandlerProtocol){
        self.handler = handler
        self.getToken = GetToken()
        self.getToken.setHandler(self)
    }
    
    public func setToken(token: String) -> Void{
        self.token = token
        self.resetPassword()
    }
    
    public func getTokenFatalError(error: GetTokenErrorFatal) {
        self.handler.resetPasswordError(ResetPasswordErrorFatal(message: error.message))
    }
    
    public func resetViaUsername(username: String) -> Void
    {
        
        self.username = username
        self.email = nil
        
        do {
            try self.getToken.getToken(GetToken.TokenTypes.CSRF)
        }catch{}
        
    }
    
    public func resetViaEmail(email: String) -> Void
    {
        
        self.username = nil
        self.email = email
        
        do {
            try self.getToken.getToken(GetToken.TokenTypes.CSRF)
        }catch{}
        
    }
    
    internal func resetPassword() -> Void {
        
        var parameters = [
            "action": "resetpassword",
            "format": "json",
            "token": self.token!
        ]
        
        if self.username != nil{
            parameters["user"] = self.username
        }else{
            parameters["email"] = self.email
        }
        
        Alamofire.request(
            .POST,
            Config.apiUrl,
            parameters: parameters
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    // Case error
                    if let result = JSON.objectForKey("error")?.objectForKey("code") {
                        
                        let resultStr : String = result as! String
                        
                        switch resultStr {
                            
                        case ResetPasswordResults.Failed.rawValue:
                            self.handler.resetPasswordError(ResetPasswordThrottle())
                            break
                        case ResetPasswordResults.NotSuchUser.rawValue:
                            self.handler.resetPasswordError(ResetPasswordBadInfo())
                            break
                        default:
                            print(resultStr)
                            self.handler.resetPasswordError(ResetPasswordErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                        }
                        
                    // Case when is success
                    }else if let result = JSON.objectForKey("resetpassword")?.objectForKey("status") {
                        
                        let resultStr : String = result as! String
                        
                        if resultStr == ResetPasswordResults.Success.rawValue {
                            self.handler.resetPasswordSuccess()
                        }else{
                            self.handler.resetPasswordError(ResetPasswordErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                        }
                        
                    // when it cant process json data
                    }else{
                        self.handler.resetPasswordError(ResetPasswordErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                    }
                
                // Case when it cant get response
                }else{
                    self.handler.resetPasswordError(ResetPasswordErrorFatal(message: GeneralErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }
        
    }
    
}

public protocol ResetPasswordHandlerProtocol {
    
    func resetPasswordSuccess()
    func resetPasswordError(error: ResetPasswordErrorFatal)
    func resetPasswordError(error: ResetPasswordThrottle)
    func resetPasswordError(error: ResetPasswordBadInfo)
    
}