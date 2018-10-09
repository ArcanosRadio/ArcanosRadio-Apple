import Foundation
import SwiftRex

public struct StreamingServerResponse: ActionProtocol, Codable {
    public let streamingServer: StreamingServer

    enum CodingKeys: String, CodingKey {
        case streamingServer = "params"
    }
}

public struct ParseQueryResponse<T: Codable>: ActionProtocol, Codable {
    public let results: [T]
}
