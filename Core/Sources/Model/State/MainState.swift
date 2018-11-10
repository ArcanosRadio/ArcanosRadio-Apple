import Foundation

public struct MainState: Equatable, Codable {
    public var app: AppState = .init()
    public var currentSong: Playlist?
    public var navigation: Sitemap = .unknown
    public var streamingServer: RequestProgress<StreamingServer>?
    public var fileCache: Transient<[String: () -> Data]> = .init([:])
    #if os(iOS) || os(macOS) || os(tvOS)
    public var connectionState: Reachability.Connection = Reachability.Connection.none
    #endif

    public init() { }
}
