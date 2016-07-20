class Config {
    static var baseApiUrl: String = "https://commons.wikimedia.org"
    static let apiUri: String = "/w/api.php"
    
    static var apiUrl: String {
        get {
            return self.baseApiUrl + self.apiUri
        }
    }
    
}
