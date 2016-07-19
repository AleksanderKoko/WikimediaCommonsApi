import Alamofire

public class GetToken {
    
    internal var handler: GetTokenHandlerProtocol?
    
    enum TokenTypes: String{
        case LoginToken = "login"
        case CreateUserToken = "createaccount"
        case CSRF = "csrf"
    }
    
    func setHandler(handler: GetTokenHandlerProtocol){
        self.handler = handler
    }
    
    func getToken(tokenType: TokenTypes) throws{
        
        if self.handler != nil {
            
            Alamofire.request(
                .GET,
                Config.apiUrl,
                parameters: [
                    "action": "query",
                    "format": "json",
                    "meta": "tokens",
                    "type": tokenType.rawValue
                ]).responseJSON { response in
                    
                    if let JSON = response.result.value {
                        
                        if let loginTokenKey = JSON.objectForKey("query")?.objectForKey("tokens")?.objectForKey("\(tokenType.rawValue)token") {
                            self.handler!.setToken(loginTokenKey as! String)
                        }else{
                            self.handler!.getTokenFatalError(GetTokenErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                        }
                        
                    }else{
                        self.handler!.getTokenFatalError(GetTokenErrorFatal(message: GeneralErrorMessages.FatalErrorCantGetResponse.rawValue))
                    }
                    
            }
            
        }else{
            throw NoHandlerException()
        }
        
    }
    
}

public protocol GetTokenHandlerProtocol {
    
    func setToken(token: String) -> Void
    func getTokenFatalError(error: GetTokenErrorFatal) -> Void
    
}