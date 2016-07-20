import Alamofire

public class Login : GetTokenHandlerProtocol {
    
    internal let handler: LoginHandlerProtocol
    internal let getToken: GetToken
    
    internal var username: String?
    internal var password: String?
    internal var token: String?
    
    internal enum LoginErrorResults : String {
        case BadToken = "badtoken"
        case Success = "PASS"
        case Failed = "FAIL"
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
    
    public func getTokenFatalError(error: GetTokenErrorFatal) {
        self.handler.loginError(error)
    }
    
    public func login(username: String, password: String) -> Void
    {
        
        self.username = username
        self.password = password
        
        do {
            try self.getToken.getToken(GetToken.TokenTypes.LoginToken)
        }catch{}
        
    }
    
    internal func sendCredentials() -> Void {
        
        Alamofire.request(
            .POST,
            Config.apiUrl,
            parameters: [
                "action": "clientlogin",
                "format": "json",
                "loginreturnurl": "http://example.org/",
                "username": self.username!,
                "password": self.password!,
                "logintoken": self.token!
            ]
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    if let result = JSON.objectForKey("clientlogin")?.objectForKey("status") {
                        
                        let resultStr : String = result as! String
                        
                        
                        switch (resultStr) {
                        case LoginErrorResults.Success.rawValue:
                            if let user = JSON.objectForKey("clientlogin")?.objectForKey("username"){
                                self.handler.loginSuccess(UserModel(username: user as! String))
                            }else{
                                self.handler.loginError(LoginErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                            }
                            break
                        case LoginErrorResults.Failed.rawValue:
                            self.handler.loginError(LoginErrorsBadCredentials())
                            break
                        default:
                            self.handler.loginError(LoginErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                            break
                        }
                        
                    }else{
                        self.handler.loginError(LoginErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                    }
                    
                }else{
                    self.handler.loginError(LoginErrorFatal(message: GeneralErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }
        
    }
    
}

public protocol LoginHandlerProtocol {
    
    func loginSuccess(user: UserModel)
    func loginError(error: GetTokenErrorFatal)
    func loginError(error: LoginErrorFatal)
    func loginError(error: LoginErrorsBadCredentials)
    
}