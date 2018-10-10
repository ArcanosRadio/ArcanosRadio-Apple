import Foundation
import RxSwift
import SwiftRex

public final class LifeCycleMiddleware: Middleware {
    public var actionHandler: ActionHandler?
    private let disposeBag = DisposeBag()

    public func handle(event: EventProtocol, getState: @escaping () -> MainState, next: @escaping (EventProtocol, @escaping () -> MainState) -> Void) {
        defer {
            next(event, getState)
        }

        guard let appLifeCycleEvent = event as? AppLifeCycleEvent else { return }

        switch appLifeCycleEvent {
        case let .boot(application, _):
            // Theme.apply()
            application.isIdleTimerDisabled = true
        case let .rotate(_, _):
            break
        case let .windowActiveChanged(_, _):
            break
        case let .windowForegroundChanged(_, _):
            break
        }
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> MainState, next: @escaping (ActionProtocol, @escaping () -> MainState) -> Void) {
        defer {
            next(action, getState)
        }
    }

    public init() { }
}
