import Foundation

/**
 * ErrorMessage Protocol
 */
public protocol ErrorMessage{
    var message: String { get }
}

enum GeneralErrorMessages: String {
    case FatalErrorCantProcessJSON
    case FatalErrorCantGetResponse
    case FatalErrorNotAHandler
}

/**
 * Login Errors
 */
public struct LoginErrorFatal: ErrorMessage{
    public var message: String
}

public struct LoginErrorsBadCredentials: ErrorMessage{
    public var message: String = "Bad Credentials"
}

public struct LoginErrorNotExists: ErrorMessage{
    public var message: String = "This user doesnt exists"
}

/**
 * ResetPassword Errors
 */
public struct ResetPasswordThrottle: ErrorMessage{
    public var message: String = "You can only reset password for a particular user once in 24 hours"
}

public struct ResetPasswordErrorFatal: ErrorMessage{
    public var message: String
}

public struct ResetPasswordBadInfo: ErrorMessage{
    public var message: String = "This User doesnt exists"
}

/**
 * LogOut Errors
 */
public struct LogOutFatalError: ErrorMessage{
    public var message: String
}

/**
 * CreateUser Errors
 */
public struct SignUpCaptcha: ErrorMessage{
    public var message: String = "Captcha needed"
}

public struct SignUpBadInput: ErrorMessage{
    public var message: String = "Bad input"
}

public struct SignUpErrorFatal: ErrorMessage{
    public var message: String
}


/**
 *
 */
public struct GetTokenErrorFatal: ErrorMessage{
    public var message: String
}

/**
 * GetCaptcha Errors
 */
public struct GetCaptchaErrorFatal: ErrorMessage{
    public var message: String
}

/**
 * GetMultimedia Errors
 */
public struct GetMultimediaErrorFatal: ErrorMessage{
    public var message: String
}

public struct UploadMultimediaErrorFatal: ErrorMessage{
    public var message: String
}