import Foundation

struct Dependencies {
    var urlSession: URLSession
    var logger: RestLogger
    
    // TODO: Move the followings into one type
    var getFileURL: (RestLogger.Content) -> URL
    var store: (Data, URL) throws -> Void
}

extension Dependencies {
    static let live = Self(
        urlSession: .shared,
        logger: .debug,
        getFileURL: {
            FileManager.default
                .temporaryDirectory
                .appendingPathComponent("RestLogger")
                .appendingPathComponent($0.id.uuidString)
        },
        store: { try $0.write(to: $1) }
    )
}

#if DEBUG
var global = Dependencies.live
#else
let global = Dependencies.live
#endif
