import Foundation

public struct MainState: Equatable, Codable {
    public var app: AppState = .init()
    public var currentSong: Playlist?
    public var navigation: Sitemap = .unknown
    public var streamingServer: RequestProgress<StreamingServer>?
    public var fileCache: Transient<[String: () -> Data]> = .init([:])

    public init() { }
}
