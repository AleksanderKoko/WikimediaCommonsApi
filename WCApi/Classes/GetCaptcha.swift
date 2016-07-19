import Alamofire

public class GetCaptcha{
    
    private var handler: GetCaptchaHandlerProtocol
    
    public init(handler: GetCaptchaHandlerProtocol){
        self.handler = handler
    }
    
    public func getCaptcha() -> Void{
        
        Alamofire.request(
            .POST,
            Config.apiUrl,
            parameters: [
                "action": "query",
                "format": "json",
                "meta": "authmanagerinfo",
                "amirequestsfor": "create"
            ]
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    if let fields =
                        JSON.objectForKey("query")?
                            .objectForKey("authmanagerinfo")?["requests"]?![0]?.objectForKey("fields")
                    {
                        if
                            let captchaId = fields.objectForKey("captchaId")?.objectForKey("value"),
                            let captchaLink = fields.objectForKey("captchaInfo")?.objectForKey("value"){
                            
                            let captchaIdString = captchaId as! String
                            let captchaLinkString = captchaLink as! String
                            let captchaFullUrlString = Config.baseApiUrl + captchaLinkString
                            
                            self.handler.success(captchaIdString, captchaUrl: captchaFullUrlString)
                        
                        }else{
                            self.handler.getCaptchaFatalError(GetCaptchaErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                        }
                        
                    }else{
                        self.handler.getCaptchaFatalError(GetCaptchaErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                    }
                    
                }else{
                    self.handler.getCaptchaFatalError(GetCaptchaErrorFatal(message: GeneralErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }
        
    }
    
}

public protocol GetCaptchaHandlerProtocol {
    
    func success(captchaId: String, captchaUrl: String)
    
    func getCaptchaFatalError(error: GetCaptchaErrorFatal)
    
}