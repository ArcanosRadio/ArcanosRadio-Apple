import Foundation
import RxSwift
import SwiftRex

public final class SongUpdaterMiddleware: Middleware {
    public typealias StateType = MainState
    public var actionHandler: ActionHandler?
    private var eventHandler: EventHandler? {
        return actionHandler as? EventHandler
    }
    private let disposeBag = DisposeBag()
    private var timerSubscription: Disposable?

    public func handle(event: EventProtocol, getState: @escaping () -> StateType, next: @escaping (EventProtocol, @escaping () -> StateType) -> Void) {
        next(event, getState)
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> StateType, next: @escaping (ActionProtocol, @escaping () -> StateType) -> Void) {
        defer {
            next(action, getState)
        }

        switch action {
        case let playlistAction as RequestProgress<Playlist>:
            handle(playlistAction: playlistAction, getState: getState, next: next)
        case let radioPlayerAction as RadioPlayerAction:
            handle(radioPlayerAction: radioPlayerAction, getState: getState, next: next)
        default:
            break
        }
    }

    private func handle(playlistAction: RequestProgress<Playlist>, getState: @escaping () -> StateType, next: @escaping (ActionProtocol, @escaping () -> StateType) -> Void) {
        playlistAction.analysis(
            onSuccess: { playlist in
                guard playlist != getState().currentSong else { return }
                actionHandler?.trigger(SongUpdaterAction.songHasChanged(playlist))

                guard let eventHandler = eventHandler else { return }

                playlist
                    .song
                    .albumArt
                    .map { $0.url }
                    .map(CachedFileEvent.fileRequested(url:))
                    .map(eventHandler.dispatch)

                playlist
                    .song
                    .lyrics
                    .map { $0.url }
                    .map(CachedFileEvent.fileRequested(url:))
                    .map(eventHandler.dispatch)

            }, onFailure: handleError(playlistAction))
    }

    private func handle(radioPlayerAction: RadioPlayerAction, getState: @escaping () -> StateType, next: @escaping (ActionProtocol, @escaping () -> StateType) -> Void) {
        switch radioPlayerAction {
        case .started:
            if let server = getState().streamingServer?.value {
                createTimer(timeInterval: server.poolingTimeActive)
            }
        case .stopped:
            timerSubscription?.dispose()
            timerSubscription = nil
        default: break
        }
    }

    public init() { }

    private func createTimer(timeInterval: TimeInterval) {
        let timer = Observable<Int>.interval(timeInterval, scheduler: ConcurrentDispatchQueueScheduler(qos: .background)).map { _ in }

        timerSubscription?.dispose()
        timerSubscription = Observable<Void>.concat(.just(()), timer).subscribe(onNext: { [weak self] in
            self?.eventHandler?.dispatch(RefreshTimerEvent.tick)
        })
    }
}

extension Middleware {
    public func handleError(_ event: EventProtocol) -> (Error) -> Void {
        return { [weak self] error in
            self?.actionHandler?.trigger(ErrorAction(error: error, message: .left(event)))
        }
    }

    public func handleError(_ action: ActionProtocol) -> (Error) -> Void {
        return { [weak self] error in
            self?.actionHandler?.trigger(ErrorAction(error: error, message: .right(action)))
        }
    }
}
