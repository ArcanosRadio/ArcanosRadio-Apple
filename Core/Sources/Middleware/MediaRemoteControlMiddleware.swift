import Foundation
import MediaPlayer
import RxSwift
import SwiftRex

extension UIEvent: EventProtocol { }

public final class MediaRemoteControlMiddleware: Middleware {
    public typealias StateType = MainState
    public var actionHandler: ActionHandler?
    public var eventHandler: EventHandler? {
        return actionHandler as? EventHandler
    }
    private let commandCenter = MPRemoteCommandCenter.shared()
    private let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
    private let disposeBag = DisposeBag()

    public init() {
    }

    public func handle(event: EventProtocol, getState: @escaping () -> StateType, next: @escaping (EventProtocol, @escaping () -> StateType) -> Void) {
        defer {
            next(event, getState)
        }

        switch event {
        case let AppLifeCycleEvent.boot(application, _):
            setupCommandCenter(for: application)
        case let uiEvent as UIEvent:
            handle(uiEvent: uiEvent)
        default: break
        }
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> StateType, next: @escaping (ActionProtocol, @escaping () -> StateType) -> Void) {
        defer {
            next(action, getState)
        }

        switch action {
        case RadioPlayerAction.started:
            assert(Thread.current.isMainThread, "Not in MainThread when handle action RadioPlayerAction.started")
            commandCenter.playCommand.isEnabled = false
            commandCenter.pauseCommand.isEnabled = true
            if #available(iOS 11.0, *) {
                nowPlayingInfoCenter.playbackState = MPNowPlayingPlaybackState.playing
            }

        case RadioPlayerAction.stopped:
            assert(Thread.current.isMainThread, "Not in MainThread when handle action RadioPlayerAction.stopped")
            commandCenter.playCommand.isEnabled = true
            commandCenter.pauseCommand.isEnabled = false
            if #available(iOS 11.0, *) {
                nowPlayingInfoCenter.playbackState = MPNowPlayingPlaybackState.paused
            }

        case let SongUpdaterAction.songHasChanged(playlist):
            let albumArt = (playlist.song.albumArt?.url.absoluteString)
                .flatMap({ getState().fileCache.value[$0]?() })
                .flatMap(UIImage.init(data:))

            updatePlayingInfoCenter(playlist: playlist, albumArt: albumArt)

        case CachedFileAction.fileAvailable:
            let state = getState()
            guard let playlist = state.currentSong else { return }

            let albumArt = (playlist.song.albumArt?.url.absoluteString)
                .flatMap({ getState().fileCache.value[$0]?() })
                .flatMap(UIImage.init(data:))

            updatePlayingInfoCenter(playlist: playlist, albumArt: albumArt)

        default: break
        }
    }

    private func updatePlayingInfoCenter(playlist: Playlist, albumArt: UIImage?) {
        assert(Thread.current.isMainThread, "Not in MainThread when updatePlayingInfoCenter(playlist:,albumArt:)")
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = playlist.song.songName
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = playlist.song.artist.artistName
        nowPlayingInfo[MPMediaItemPropertyArtist] = playlist.song.artist.artistName
        nowPlayingInfo[MPMediaItemPropertyMediaType] = MPMediaType.music.rawValue
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = 0.0
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0

        if let albumArt = albumArt {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: albumArt.size) { size in
                return albumArt
            }
        }

        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

    private func handle(uiEvent: UIEvent) {
        assert(Thread.current.isMainThread, "Not in MainThread when handle(uiEvent:)")

        switch (uiEvent.type, uiEvent.subtype) {
        case (.remoteControl, .remoteControlTogglePlayPause): break
        case (.remoteControl, .remoteControlPlay): break
        case (.remoteControl, .remoteControlPause): break
        case (.remoteControl, .remoteControlStop): break
        default: break
        }
    }

    private func setupCommandCenter(for application: UIApplication) {
        assert(Thread.current.isMainThread, "Not in MainThread when setupCommandCenter(for:)")
        application.beginReceivingRemoteControlEvents()

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.eventHandler?.dispatch(MediaControlEvent.userWantsToToggle)
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.eventHandler?.dispatch(MediaControlEvent.userWantsToPause)
            return .success
        }

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.eventHandler?.dispatch(MediaControlEvent.userWantsToResume)
            return .success
        }

        commandCenter.previousTrackCommand.isEnabled = false
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = false
        commandCenter.stopCommand.isEnabled = false
    }
}
