import Alamofire

public class UploadMultimedia : GetTokenHandlerProtocol {
    
    internal let handler: UploadMultimediaHandlerProtocol
    internal let getToken: GetToken
    
    internal var username: UserModel?
    internal var title: String?
    internal var description: String?
    internal var license: MultimediaModel.Licenses?
    internal var categories: [String]?
    internal var comment: String?
    internal var token: String?
    internal var imageData: NSData?
    internal var text: String?
    
    internal struct Results{
        let Success = "Success"
    }
    
    internal enum ResetPasswordResults : String {
        case Success = "success"
        case Failed = "throttled-mailpassword"
        case NotSuchUser = "nosuchuser"
    }
    
    public init(handler: UploadMultimediaHandlerProtocol){
        self.handler = handler
        self.getToken = GetToken()
        self.getToken.setHandler(self)
    }
    
    public func setToken(token: String) -> Void{
        self.token = token
        self.uploadNetworking()
    }
    
    public func getTokenFatalError(error: GetTokenErrorFatal) {
        self.handler.uploadMultimediaError(error)
    }
    
    public func upload(user: UserModel, title: String, description: String, comment: String, license: String, categories: [String], imageData: NSData, date: String?) -> Void
    {
        
        self.title = title
        self.comment = comment
        self.imageData = imageData
        self.text = self.buildText(user, description: description, license: license, categories: categories, date: date)
        
        do {
            try self.getToken.getToken(GetToken.TokenTypes.CSRF)
        }catch{}
        
    }
    
    internal func buildText(user: UserModel, description: String, license: String, categories: [String], date: String?) -> String{
        
        var dateStr: String = ""
        
        if date != nil{
            dateStr = "|date=\(date)\n"
        }else{
            dateStr = "|date=\(self.getCurrentDateString())\n"
        }
        
        let fileDescHeader = "=={{int:filedesc}}==\n{{Information\n"
        let description = "|description={{en|1=\(description)}} \n"
        let source = "|source={{own}}\n"
        let author = "|author=[[User:\(user.username)|\(user.username)]]\n"
        let permission = "|permission=\n"
        let otherVersions = "|other versions=\n"
        let fileDescEnd = "}}\n\n"
        
        let licenseStr = "=={{int:license-header}}==\n{{self|\(license)}}\n\n"
        
        var textStr = fileDescHeader + description + dateStr + source + author + permission + otherVersions + fileDescEnd + licenseStr
        
        for category in categories {
            textStr += "[[Category:\(category)]]\n"
        }
        
        return textStr
        
    }
    
    internal func uploadNetworking() -> Void {
        
        print("Starting to upload")
        
        Alamofire.upload(
            .POST,
            Config.apiUrl,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: self.imageData!, name: "file", fileName: "\(self.title).jpeg", mimeType: "image/jpeg")
                multipartFormData.appendBodyPart(data: "upload".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"action")
                multipartFormData.appendBodyPart(data: "json".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"format")
                multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"ignorewarnings")
                multipartFormData.appendBodyPart(data: self.comment!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"comment")
                multipartFormData.appendBodyPart(data: self.token!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"token")
                multipartFormData.appendBodyPart(data: self.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"text")
                multipartFormData.appendBodyPart(data: "\(self.title!).jpeg".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"filename")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value{
                        
                            if let result = JSON.objectForKey("upload")?.objectForKey("result"){
                                
                                print(result) // IT WORKS HERE
                                
                            }else{
                                
                                print("Jo dhe kete here")
                                
                            }
                            
                        }else{
                            print("Cant parse the JSON")
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
        /*Alamofire.request(
            .POST,
            Config.apiUrl,
            parameters: [
                "action": "upload",
                "format": "json",
                "ignorewarnings": 1,
                "filename": self.title!,
                "comment": self.comment!,
                "token": self.token!,
            ]
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    // Case error
                    /*if let result = JSON.objectForKey("error")?.objectForKey("code") {
                        
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
                    */
                    // Case when it cant get response
                }else{
                    self.handler.uploadMultimediaError(UploadMultimediaErrorFatal(message: GeneralErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }*/
        
    }
    
    internal func getCurrentDateString() -> String{
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.stringFromDate(NSDate())
    }
    
}

public protocol UploadMultimediaHandlerProtocol {
    
    func uploadMultimediaSuccess()
    func uploadMultimediaError(error: UploadMultimediaErrorFatal)
    func uploadMultimediaError(error: GetTokenErrorFatal)
    
}