import Foundation

struct RestOperation<Resource> {
    let buildRequest: () -> RestRequest
    let parse: (Data) throws -> Resource
}

extension RestOperation where Resource: Decodable {
    init(_ buildRequest: @escaping () -> RestRequest) {
        self.buildRequest = buildRequest
        self.parse = { try JSONDecoder().decode(Resource.self, from: $0) }
    }
}
