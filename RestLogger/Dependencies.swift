import Foundation

struct Dependencies {
    var urlSession: URLSession
    var logger: RestLogger<String>
}

#if DEBUG
var global = Dependencies(urlSession: .shared, logger: .debug)
#else
let global = Dependencies(urlSession: .shared, logger: .debug)
#endif
