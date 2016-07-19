public struct UserModel {
    public var username: String
    
    public init(username: String){
        self.username = username
    }
}

public struct MultimediaModel{
    
    public var name: String
    public var url: NSURL
    public var descriptionUrl: NSURL
    public var mediaType: String
    
    public struct MediaTypes {
        public static let image = "BITMAP"
        public static let video = "VIDEO"
        public static let audio = "AUDIO"
    }
    
    public struct Licenses {
        public static let CreativeCommonsAttributionShareAlike40 = "cc-by-sa-4.0"
        public static let CreativeCommonsAttributionShareAlike30 = "cc-by-sa-3.0"
        public static let CreativeCommonsAttributionShare40 = "cc-by-4.0"
        public static let CreativeCommonsAttributionShare30 = "cc-by-3.0"
        public static let CreativeCommonsZero = "cc-zero"
    }
    
}