import Foundation

public protocol GetTokenHandlerProtocol {
    
    func setToken(token: String) -> Void
    
    func getTokenFatalError(error: ErrorMessageGeneral) -> Void
    
}