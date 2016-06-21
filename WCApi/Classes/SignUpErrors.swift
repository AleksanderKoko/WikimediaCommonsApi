public struct SignUpErrorFatal: ErrorMessage{
    public var message: String
}

public struct SignUpErrorsBadCredentials: ErrorMessage{
    public var message: String = "Bad Username or Password"
}

public struct SignUpCaptchaNeeded: ErrorMessage{
    public var message: String = "Captcha needed"
}

public struct SignUpErrorExists: ErrorMessage{
    public var message: String = "This user already exists"
}