class Config {
    public static var baseApiUrl: String = "https://commons.wikimedia.org"
    public static let apiUri: String = "/w/api.php"
    
    public static var apiUrl: String {
        get {
            return self.baseApiUrl + self.apiUri
        }
    }
    
}
