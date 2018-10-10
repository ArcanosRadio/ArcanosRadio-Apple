import Foundation

public struct ParseResource: Codable, Equatable {
    public let name: String
    public let url: URL
}

public struct ParseConfigResponse<T: Codable>: Codable {
    public let params: T
}

public struct ParseQueryResponse<T: Codable>: Codable {
    public let results: [T]
}
