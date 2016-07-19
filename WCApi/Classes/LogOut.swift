import Alamofire

public class LogOut {
    
    internal let handler: LogOutHandlerProtocol
    
    public init(handler: LogOutHandlerProtocol){
        self.handler = handler
    }
    
    public func logOut() -> Void {
        
        Alamofire.request(
            .POST,
            Config.apiUrl,
            parameters: [
                "action": "logout",
                "format": "json"
            ]
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    self.handler.logOutSuccess()
                }else{
                    self.handler.logOutError(LogOutFatalError(message: GeneralErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }
        
    }
    
}

public protocol LogOutHandlerProtocol{
    func logOutSuccess()
    func logOutError(error: LogOutFatalError)
}