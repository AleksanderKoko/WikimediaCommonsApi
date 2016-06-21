import Alamofire

public class GetMultimedia{
    
    internal let handler: GetMultimediaHandlerProtocol
    
    enum ErrorMessages: String {
        case FatalErrorCantProcessJSON
        case FatalErrorCantGetResponse
        case FatalErrorUnknownResultFromJSON
        case FatalErrorCantGetResultFromJSON
    }
    
    init(handler: GetMultimediaHandlerProtocol){
        self.handler = handler
    }
    
    func get(user: UserModel) -> Void
    {
        
        Alamofire.request(
            .POST,
            "https://commons.wikimedia.org/w/api.php",
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
                        self.handler.getMultimediaError(GetMultimediaErrorFatal(message: ErrorMessages.FatalErrorCantGetResultFromJSON.rawValue))
                    }
                    
                }else{
                    self.handler.getMultimediaError(GetMultimediaErrorFatal(message: ErrorMessages.FatalErrorCantGetResponse.rawValue))
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
                
                if (mediaTypeString == MediaTypes.image) || (mediaTypeString == MediaTypes.video) {
                    multimediaArray.append(MultimediaModel(name: name, url: url, descriptionUrl: descriptionUrl, mediaType: mediaTypeString))
                }
                
            }
            
        }
        
        
        self.handler.setMultimedia(multimediaArray)
        
        
    }
    
}