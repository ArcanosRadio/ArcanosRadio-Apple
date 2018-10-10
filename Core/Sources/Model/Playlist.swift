import Foundation

public struct Playlist: Codable, Equatable {
    public let id: String
    public let title: String
    public let song: Song
    public let createdAt: Date
    public let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "objectId"
        case title, song, createdAt, updatedAt
    }
}
