/*import Foundation
import Alamofire

protocol WCSignUpHandler {
    
    //func wcSignUpSuccess(user: WCUser)
    
    func wcSignUpError(error: WCSignUpErrorFatal)
    
    func wcSetCaptchaText(url: NSURL)
    
    func wcSetToken(token: String)
    
    func wcSetCaptchaId(id: String)
    
    //func wcSignUpError(error: WCLoginErrorsBadCredentials)
    
    //func wcSignUpError(error: WCLoginErrorNotExists)
    
}


enum SignUpResults : String {
    case NeedCaptcha = "NeedCaptcha"
    case WrongPass = "WrongPass"
    case NoName = "NoName"
    case NotExists = "NotExists"
    case Success = "Success"
}

struct WCSignUpErrorFatal: WCErrors{
    var message: String
}

class WCSignUpApi {
    
    enum ErrorMessages: String {
        case FatalErrorCantProcessJSON
        case FatalErrorCantGetResponse
        case FatalErrorUnknownResultFromJSON
        case FatalErrorCantGetResultFromJSON
    }
    
    static let baseUrl = "https://en.wikipedia.org"
    
    static func getToken(handler: WCSignUpHandler){
        
        Alamofire.request(
            .POST,
            "https://en.wikipedia.org/w/api.php",
            parameters: [
                "action": "query",
                "format": "json",
                "meta": "tokens",
                "type": "createaccount"
            ]).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    print(JSON)
                    
                    if let signUpTokenKey = JSON.objectForKey("query")?.objectForKey("tokens")?.objectForKey("createaccounttoken") {
                        handler.wcSetToken(signUpTokenKey as! String)
                    }else{
                        handler.wcSignUpError(WCSignUpErrorFatal(message: ErrorMessages.FatalErrorCantProcessJSON.rawValue))
                    }
                    
                }else{
                    handler.wcSignUpError(WCSignUpErrorFatal(message: ErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }
        
    }
    
    static func signUp(username: String, password: String, email: String?, captchaText: String, token: String, captchaId: String, handler: WCSignUpHandler) -> Void {
        
        Alamofire.request(
            .POST,
            "https://en.wikipedia.org/w/api.php",
            parameters: [
                "action": "createaccount",
                "format": "json",
                "name": username,
                "password": password,
                "token": token,
                "captchaword": captchaText,
                "captchaid": captchaId
            ]
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    print(JSON)
                    print(captchaText)
                    
                    if let result = JSON.objectForKey("createaccount")?.objectForKey("result") {
                        
                        let resultStr : String = result as! String
                        
                        switch (resultStr) {
                        case SignUpResults.NeedCaptcha.rawValue:
                            
                            if
                                let captchaUrl = JSON.objectForKey("createaccount")?.objectForKey("captcha")?.objectForKey("url")
                            
                            {
                                
                                if let captchaId = JSON.objectForKey("createaccount")?.objectForKey("captcha")?.objectForKey("id") {
                                    let urlString = self.baseUrl + (captchaUrl as! String)
                                    let url = NSURL(string: urlString)
                                    handler.wcSetCaptchaText(url!)
                                    handler.wcSetCaptchaId(captchaId as! String);
                                }else{
                                    handler.wcSignUpError(WCSignUpErrorFatal(message: ErrorMessages.FatalErrorCantProcessJSON.rawValue))
                                }
                                
                            }else{
                                handler.wcSignUpError(WCSignUpErrorFatal(message: ErrorMessages.FatalErrorCantProcessJSON.rawValue))
                            }
                            
                            break
                        case LoginErrorResults.NoName.rawValue,
                        LoginErrorResults.EmptyPass.rawValue,
                        LoginErrorResults.WrongPass.rawValue:
                            //handler.wcLoginError(WCLoginErrorsBadCredentials())
                            break
                        case LoginErrorResults.NotExists.rawValue:
                            //handler.wcLoginError(WCLoginErrorNotExists())
                            break
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
    
}*/