public protocol SignUpHandlerProtocol {
    
    func signUpError(error: ErrorMessageGeneral)
    
    func signUpError(error: SignUpErrorFatal)
    
    func signUpError(error: SignUpErrorExists)
    
    func signUpError(error: SignUpCaptchaNeeded, url: NSURL)
    
    func signUpError(error: SignUpErrorsBadCredentials)
    
    func signUpSuccess()
    
}