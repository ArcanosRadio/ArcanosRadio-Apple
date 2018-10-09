import Foundation

public struct Song: Codable, Equatable {
    public let id: String
    public let songName: String
    public let artist: Artist
    public let albumArt: ParseResource?
    public let albumArtState: ResourceState
    public let lyrics: ParseResource?
    public let lyricsState: ResourceState
    public let hasRightsContract: Bool
    public let tags: [String]
    public let createdAt: Date
    public let updatedAt: Date
}
