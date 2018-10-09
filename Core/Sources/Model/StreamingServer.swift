import Foundation

public struct StreamingServer: Equatable, Codable {
    public let streamingUrl: URL
    public let poolingTimeActive: TimeInterval
    public let poolingTimeBackground: TimeInterval
    public let shareUrl: String
    public let rightsFlag: Bool
}
