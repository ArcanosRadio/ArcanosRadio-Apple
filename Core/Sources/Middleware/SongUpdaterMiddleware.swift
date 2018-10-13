import Foundation
import RxSwift
import SwiftRex

public final class SongUpdaterMiddleware: Middleware {
    public var actionHandler: ActionHandler?
    private var eventHandler: EventHandler? {
        return actionHandler as? EventHandler
    }
    private let disposeBag = DisposeBag()
    private var timerSubscription: Disposable?

    public func handle(event: EventProtocol, getState: @escaping () -> MainState, next: @escaping (EventProtocol, @escaping () -> MainState) -> Void) {
        defer {
            next(event, getState)
        }
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> MainState, next: @escaping (ActionProtocol, @escaping () -> MainState) -> Void) {
        defer {
            next(action, getState)
        }

        switch action {
        case let playlistAction as RequestProgress<Playlist>:
            handle(playlistAction: playlistAction, getState: getState, next: next)
        case let streamingServerAction as RequestProgress<StreamingServer>:
            handle(serverAction: streamingServerAction, getState: getState, next: next)
        default:
            break
        }
    }

    private func handle(playlistAction: RequestProgress<Playlist>, getState: @escaping () -> MainState, next: @escaping (ActionProtocol, @escaping () -> MainState) -> Void) {
        playlistAction.analysis(
            onSuccess: { playlist in
                guard playlist != getState().currentSong else { return }
                actionHandler?.trigger(SongUpdaterAction.songHasChanged(playlist))
            }, onFailure: handleError(playlistAction))
    }

    private func handle(serverAction: RequestProgress<StreamingServer>, getState: @escaping () -> MainState, next: @escaping (ActionProtocol, @escaping () -> MainState) -> Void) {
        serverAction.analysis(
            onSuccess: { server in
                createTimer(timeInterval: server.poolingTimeActive)
            },
            onFailure: handleError(serverAction))
    }

    public init() { }

    private func createTimer(timeInterval: TimeInterval) {
        timerSubscription?.dispose()
        timerSubscription =
            Observable<Void>
                .concat(
                    .just(()),
                    Observable<Int>
                        .interval(timeInterval,
                                  scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                        .map { _ in }
                ).subscribe(onNext: { [weak self] in
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
