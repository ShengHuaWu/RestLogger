@testable import RestLogger

extension RestLogger where Content == String {
    static let test = Self { _ in
        fatalError("Unimplemented yet")
    }
}
