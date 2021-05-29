@testable import RestLogger

extension Dependencies {
    static let test = Dependencies(
        urlSession: .shared,
        logger: .test,
        getFileURL: { _ in fatalError("Unimplemented yet") },
        store: { _, _ in fatalError("Unimplemented yet") }
    )
}
