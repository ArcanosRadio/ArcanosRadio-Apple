import Foundation
import RxSwift
import SwiftRex

public final class SongUpdaterMiddleware: Middleware {
    public var actionHandler: ActionHandler?
    private var eventHandler: EventHandler? {
        return actionHandler as? EventHandler
    }
    private let disposeBag = DisposeBag()
    private var timer: Timer?

    public func handle(event: EventProtocol, getState: @escaping () -> MainState, next: @escaping (EventProtocol, @escaping () -> MainState) -> Void) {
        defer {
            next(event, getState)
        }
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> MainState, next: @escaping (ActionProtocol, @escaping () -> MainState) -> Void) {
        defer {
            next(action, getState)
        }

        if case RequestProgress<Playlist>.success(let playlist) = action, playlist != getState().currentSong {
            actionHandler?.trigger(SongUpdaterAction.songHasChanged(playlist))
        }

        guard case RequestProgress<StreamingServer>.success(let streamingServer) = action else { return }

        createTimer(timeInterval: streamingServer.poolingTimeActive)
    }

    public init() { }

    private func createTimer(timeInterval: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            self?.eventHandler?.dispatch(RefreshTimerEvent.tick)
        }
        timer?.fire()
    }
}
