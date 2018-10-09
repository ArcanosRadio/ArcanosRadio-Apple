import Foundation

public struct Artist: Codable, Equatable {
    public let id: String
    public let artistName: String
    public let tags: [String]
    public let url: URL?
    public let twitterTimeline: String?
    public let createdAt: Date
    public let updatedAt: Date
}
