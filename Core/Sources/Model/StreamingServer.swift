import Foundation

public struct StreamingServer: Codable, Equatable {
    public let streamingUrl: URL
    public let poolingTimeActive: TimeInterval
    public let poolingTimeBackground: TimeInterval
    public let shareUrl: String
    public let rightsFlag: Bool

    enum CodingKeys: String, CodingKey {
        case streamingUrl = "iphoneStreamingUrl"
        case poolingTimeActive = "iphonePoolingTimeActive"
        case poolingTimeBackground = "iphonePoolingTimeBackground"
        case shareUrl = "iphoneShareUrl"
        case rightsFlag = "iphoneRightsFlag"
    }
}
