import Alamofire

public class Login : GetTokenHandlerProtocol {
    
    internal let handler: LoginHandlerProtocol
    internal let getToken: GetToken
    
    internal var username: String?
    internal var password: String?
    internal var token: String?
    
    enum ErrorMessages: String {
        case FatalErrorCantProcessJSON
        case FatalErrorCantGetResponse
        case FatalErrorUnknownResultFromJSON
        case FatalErrorCantGetResultFromJSON
    }
    
    internal enum LoginErrorResults : String {
        case EmptyPass = "EmptyPass"
        case WrongPass = "WrongPass"
        case NoName = "NoName"
        case NotExists = "NotExists"
        case Success = "Success"
        case Failed = "Failed"
    }
    
    public init(handler: LoginHandlerProtocol){
        self.handler = handler
        self.getToken = GetToken()
        self.getToken.setHandler(self)
    }
    
    public func setToken(token: String) -> Void{
        self.token = token
        sendCredentials()
    }
    
    public func getTokenFatalError(error: ErrorMessageGeneral) {
        self.handler.loginError(error)
    }
    
    public func login(username: String, password: String) -> Void
    {
        
        self.username = username
        self.password = password
        
        do {
            try self.getToken.getToken(TokenTypes.LoginToken)
        }catch{}
        
    }
    
    internal func sendCredentials() -> Void {
        
        Alamofire.request(
            .POST,
            "https://en.wikipedia.org/w/api.php",
            parameters: [
                "action": "login",
                "format": "json",
                "lgname": self.username!,
                "lgpassword": self.password!,
                "lgtoken": self.token!
            ]
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    if let result = JSON.objectForKey("login")?.objectForKey("result") {
                        
                        let resultStr : String = result as! String
                        
                        switch (resultStr) {
                        case LoginErrorResults.Success.rawValue:
                            let userJson = JSON.objectForKey("login")
                            if let user: UserModel = self.buildUser(userJson as! NSDictionary){
                                self.handler.loginSuccess(user)
                            }else{
                                self.handler.loginError(LoginErrorFatal(message: ErrorMessages.FatalErrorCantProcessJSON.rawValue))
                            }
                            break
                        case    LoginErrorResults.NoName.rawValue,
                                LoginErrorResults.EmptyPass.rawValue,
                                LoginErrorResults.WrongPass.rawValue,
                                LoginErrorResults.Failed.rawValue:
                            self.handler.loginError(LoginErrorsBadCredentials())
                            break
                        case LoginErrorResults.NotExists.rawValue:
                            self.handler.loginError(LoginErrorNotExists())
                            break
                        default:
                            self.handler.loginError(LoginErrorFatal(message: ErrorMessages.FatalErrorUnknownResultFromJSON.rawValue))
                            break
                        }
                        
                    }else{
                        self.handler.loginError(LoginErrorFatal(message: ErrorMessages.FatalErrorCantGetResultFromJSON.rawValue))
                    }
                    
                }else{
                    self.handler.loginError(LoginErrorFatal(message: ErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }
        
    }
    
    internal func buildUser(userJson: NSDictionary) -> UserModel?
    {
        if
            let token: String = userJson.objectForKey("lgtoken") as? String ,
            let username: String = userJson.objectForKey("lgusername") as? String,
            let id: Int = userJson.objectForKey("lguserid") as? Int,
            let sessionId: String = userJson.objectForKey("sessionid") as? String
        {
            return UserModel(token: token, username: username, id: id, sessionId: sessionId)
        }else{
            return nil
        }
    }
    
}