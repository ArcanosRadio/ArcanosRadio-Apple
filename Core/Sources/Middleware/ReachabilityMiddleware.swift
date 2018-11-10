import Foundation
import RxSwift
import SwiftRex

public final class ReachabilityMiddleware: Middleware {
    public typealias StateType = Reachability.Connection

    public init() { }

    public var actionHandler: ActionHandler? {
        didSet {
            guard actionHandler != nil else { return }
            startReachability()
        }
    }
    private var reachability: Reachability?

    public func handle(event: EventProtocol, getState: @escaping () -> StateType, next: @escaping (EventProtocol, @escaping () -> StateType) -> Void) {
        next(event, getState)
    }
    
    public func handle(action: ActionProtocol, getState: @escaping () -> StateType, next: @escaping (ActionProtocol, @escaping () -> StateType) -> Void) {
        next(action, getState)
    }

    private func startReachability() {
        guard let eventHandler = actionHandler as? EventHandler else { return }
        reachability = Reachability()

        guard let reachability = self.reachability else {
            eventHandler.dispatch(ReachabilityEvent.notConfigure)
            return
        }

        reachability.whenReachable = { reachability in
            eventHandler.dispatch(reachability.connection == .wifi ? ReachabilityEvent.wifi : .cellular)
        }
        
        reachability.whenUnreachable = { _ in
            eventHandler.dispatch(ReachabilityEvent.offline)
        }

        do {
            try reachability.startNotifier()
        } catch {
            eventHandler.dispatch(ReachabilityEvent.error(error))
        }
    }
}
