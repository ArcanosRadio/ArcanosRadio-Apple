import Foundation

public struct Song: Equatable, Codable {
    public let id: String
    public let songName: String
    public let artist: Artist
    public let albumArt: URL?
    public let albumArtState: ResourceState
    public let lyrics: URL?
    public let lyricsState: ResourceState
    public let hasRightsContract: Bool
    public let tags: [String]
    public let createdAt: Date
    public let updatedAt: Date
}
