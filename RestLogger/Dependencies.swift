struct Dependencies {
    var logger: RestLogger<String>
}

#if DEBUG
var global = Dependencies(logger: .debug)
#else
let global = Dependencies(logger: .debug)
#endif
