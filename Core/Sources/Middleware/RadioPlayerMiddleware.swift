import Foundation
import RxSwift
import SwiftRex

public final class RadioPlayerMiddleware: Middleware {
    public typealias StateType = MainState
    public var actionHandler: ActionHandler?
    private let radioPlayer = RadioPlayer()
    private let disposeBag = DisposeBag()

    public init() {
        radioPlayer
            .subscribe(onNext: { [weak self] action in (self?.actionHandler as? EventHandler)?.dispatch(action) })
            .disposed(by: disposeBag)
    }

    public func handle(event: EventProtocol, getState: @escaping () -> StateType, next: @escaping (EventProtocol, @escaping () -> StateType) -> Void) {
        defer {
            next(event, getState)
        }


        let state = getState()

        if state.connectionState == .none
            && [ReachabilityEvent.cellular, .wifi].contains(event as? ReachabilityEvent) {
            actionHandler?.trigger(RadioPlayerAction.retry)
        }

        guard let radioPlayerEvent = event as? RadioPlayerEvent else { return }

        switch radioPlayerEvent {
        case .paused, .notEnoughBuffer, .noItemToPlay, .failure, .evaluatingBufferingRate, .stopped:
            if state.isPlaying && state.userWantsToListen {
                actionHandler?.trigger(RadioPlayerAction.retry)
            }
            actionHandler?.trigger(RadioPlayerAction.stopped)

        case .playing:
            actionHandler?.trigger(RadioPlayerAction.started)
        }
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> StateType, next: @escaping (ActionProtocol, @escaping () -> StateType) -> Void) {
        defer {
            next(action, getState)
        }

        let state = getState()

        switch action {
        case RequestProgress<StreamingServer>.success(let streamingServer):
            radioPlayer.configure(url: streamingServer.streamingUrl)
            guard state.userWantsToListen,
                !radioPlayer.isPlaying,
                state.connectionState != .none else { return }

            radioPlayer.play()

        case RadioPlayerAction.retry:
            guard state.userWantsToListen,
                !radioPlayer.isPlaying,
                let streamingServer = state.streamingServer?.value else { return }

            radioPlayer.configure(url: streamingServer.streamingUrl)
            radioPlayer.play()

        case RadioPlayerAction.userWantsToResume:
            guard !radioPlayer.isPlaying,
                state.connectionState != .none else { return }

            radioPlayer.play()

        case ReachabilityEvent.error, ReachabilityEvent.notConfigure, ReachabilityEvent.offline, RadioPlayerAction.userWantsToPause:
            radioPlayer.stop()

        default: break
        }
    }
}
