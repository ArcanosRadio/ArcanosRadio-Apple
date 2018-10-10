import Foundation

public struct MainState: Equatable, Codable {
    public var app: AppState = .init()
    public var currentSong: Playlist?
    public var streamingServer: RequestProgress<StreamingServer>?

    public init() { }
}
