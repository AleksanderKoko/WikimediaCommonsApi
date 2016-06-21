public protocol LoginHandlerProtocol {
    
    func loginSuccess(user: UserModel)
    
    func loginError(error: ErrorMessageGeneral)
    
    func loginError(error: LoginErrorFatal)
    
    func loginError(error: LoginErrorsBadCredentials)
    
    func loginError(error: LoginErrorNotExists)
    
}