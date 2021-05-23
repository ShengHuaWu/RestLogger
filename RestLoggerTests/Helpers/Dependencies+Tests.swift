@testable import RestLogger

extension Dependencies {
    static let test = Dependencies(urlSession: .shared, logger: .test)
}
