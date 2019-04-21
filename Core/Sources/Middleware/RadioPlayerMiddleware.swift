import Foundation
import SwiftRex_ReachabilityMiddleware
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

        radioPlayer.activateSession()
    }

    public func handle(event: EventProtocol, getState: @escaping () -> StateType, next: @escaping (EventProtocol, @escaping () -> StateType) -> Void) {
        defer {
            next(event, getState)
        }

        let state = getState()

        switch event {
        case ReachabilityEvent.cellular where state.connectionState == .none,
             ReachabilityEvent.wifi where state.connectionState == .none:
            actionHandler?.trigger(RadioPlayerAction.retry)
        case RadioPlayerEvent.paused,
             RadioPlayerEvent.notEnoughBuffer,
             RadioPlayerEvent.noItemToPlay,
             RadioPlayerEvent.failure,
             RadioPlayerEvent.evaluatingBufferingRate,
             RadioPlayerEvent.stopped:
            if state.isPlaying && state.userWantsToListen {
                actionHandler?.trigger(RadioPlayerAction.retry)
            }
            if state.isPlaying {
                actionHandler?.trigger(RadioPlayerAction.stopped)
            }
        case RadioPlayerEvent.playing:
            actionHandler?.trigger(RadioPlayerAction.started)
        case MediaControlEvent.userWantsToPause:
            actionHandler?.trigger(RadioPlayerAction.playerShouldBePlaying(false))
        case MediaControlEvent.userWantsToResume:
            actionHandler?.trigger(RadioPlayerAction.playerShouldBePlaying(true))
        default: break
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

        case let RadioPlayerAction.playerShouldBePlaying(userChoice) where userChoice:
            guard !radioPlayer.isPlaying,
                state.connectionState != .none else { return }

            radioPlayer.play()

        case ReachabilityEvent.error, ReachabilityEvent.notConfigure, ReachabilityEvent.offline:
            radioPlayer.stop()

        case let RadioPlayerAction.playerShouldBePlaying(userChoice) where !userChoice:
            radioPlayer.stop()

        default: break
        }
    }
}
