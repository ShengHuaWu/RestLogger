extension Error {
    var restErrorContent: String {
        """
        REST Error:
        \(localizedDescription)
        """
    }
}
