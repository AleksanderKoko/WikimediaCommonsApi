import Alamofire

enum TokenTypes: String{
    case LoginToken = "login"
    case CreateUserToken = "createaccount"
}

public class GetToken {
    
    internal var handler: GetTokenHandlerProtocol?
    
    enum ErrorMessages: String {
        case FatalErrorCantProcessJSON
        case FatalErrorCantGetResponse
        case FatalErrorUnknownResultFromJSON
        case FatalErrorNotAHandler
    }
    
    func setHandler(handler: GetTokenHandlerProtocol){
        self.handler = handler
    }
    
    func getToken(tokenType: TokenTypes) throws{
        
        if self.handler != nil {
            
            Alamofire.request(
                .GET,
                "https://en.wikipedia.org/w/api.php",
                parameters: [
                    "action": "query",
                    "format": "json",
                    "meta": "tokens",
                    "type": tokenType.rawValue
                ]).responseJSON { response in
                    
                    if let JSON = response.result.value {
                        
                        if let loginTokenKey = JSON.objectForKey("query")?.objectForKey("tokens")?.objectForKey("logintoken") {
                            self.handler!.setToken(loginTokenKey as! String)
                        }else{
                            self.handler!.getTokenFatalError(ErrorMessageGeneral(message: ErrorMessages.FatalErrorCantProcessJSON.rawValue))
                        }
                        
                    }else{
                        self.handler!.getTokenFatalError(ErrorMessageGeneral(message: ErrorMessages.FatalErrorCantGetResponse.rawValue))
                    }
                    
            }
            
        }else{
            throw NoHandlerError()
        }
        
    }
    
}