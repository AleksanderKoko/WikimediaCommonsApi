import Alamofire

public class GetMultimedia{
    
    internal let handler: GetMultimediaHandlerProtocol
    
    public init(handler: GetMultimediaHandlerProtocol){
        self.handler = handler
    }
    
    public func get(user: UserModel) -> Void
    {
        
        Alamofire.request(
            .POST,
            Config.apiUrl,
            parameters: [
                "action": "query",
                "format": "json",
                "list": "allimages",
                "aisort": "timestamp",
                "aiprop": "url|mediatype",
                "aiuser": user.username,
                "ailimit": "max"
            ]
            ).responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    if let allImagesArray = JSON.objectForKey("query")?.objectForKey("allimages") {
                        
                        self.buildMultimedia(allImagesArray as! NSArray)
                        
                    }else{
                        self.handler.getMultimediaError(GetMultimediaErrorFatal(message: GeneralErrorMessages.FatalErrorCantProcessJSON.rawValue))
                    }
                    
                }else{
                    self.handler.getMultimediaError(GetMultimediaErrorFatal(message: GeneralErrorMessages.FatalErrorCantGetResponse.rawValue))
                }
                
        }
        
    }
    
    internal func buildMultimedia(mediaJson: NSArray) -> Void
    {
        
        var multimediaArray = [MultimediaModel]()
        
        for media in mediaJson {
            
            if
                let name: String = media.objectForKey("name") as? String,
                let descriptionUrlString: String = media.objectForKey("descriptionurl") as? String,
                let urlString: String = media.objectForKey("url") as? String,
                let mediaTypeString: String = media.objectForKey("mediatype") as? String,
            
                let url: NSURL = NSURL(string: urlString),
                let descriptionUrl: NSURL = NSURL(string: descriptionUrlString)
            {
                
                if
                    (mediaTypeString == MultimediaModel.MediaTypes.image) ||
                    (mediaTypeString == MultimediaModel.MediaTypes.video) ||
                    (mediaTypeString == MultimediaModel.MediaTypes.audio) {
                    multimediaArray.append(MultimediaModel(name: name, url: url, descriptionUrl: descriptionUrl, mediaType: mediaTypeString))
                }
                
            }
            
        }
        
        self.handler.setMultimedia(multimediaArray)
        
    }
    
}

public protocol GetMultimediaHandlerProtocol{
    
    func setMultimedia(multimedia: [MultimediaModel])
    func getMultimediaError(error: GetMultimediaErrorFatal)
    
}