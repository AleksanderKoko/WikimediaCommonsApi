public struct LoginErrorFatal: ErrorMessage{
    public var message: String
}

public struct LoginErrorsBadCredentials: ErrorMessage{
    public var message: String = "Bad Credentials"
}

public struct LoginErrorNotExists: ErrorMessage{
    public var message: String = "This user doesnt exists"
}