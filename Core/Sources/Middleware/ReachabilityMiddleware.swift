import Foundation
import RxSwift
import SwiftRex

public final class ReachabilityMiddleware: Middleware {
    public typealias StateType = ReachabilityStatus

    public init() { }

    public var actionHandler: ActionHandler? {
        didSet {
            disposeBag = DisposeBag()
            guard let eventHandler = actionHandler as? EventHandler else { return }

            guard let reachabilityService = try? DefaultReachabilityService() else {
                eventHandler.dispatch(ReachabilityEvent.notConfigure)
                return
            }

            reachabilityService.reachability.subscribe(onNext: { status in
                switch status {
                case .unreachable:
                    eventHandler.dispatch(ReachabilityEvent.offline)
                case let .reachable(viaWiFi):
                    eventHandler.dispatch(viaWiFi ? ReachabilityEvent.wifi : .cellular)
                }
            }, onError: { error in
                eventHandler.dispatch(ReachabilityEvent.error(error))
            }).disposed(by: disposeBag)
        }
    }
    private var disposeBag = DisposeBag()

    public func handle(event: EventProtocol, getState: @escaping () -> ReachabilityStatus, next: @escaping (EventProtocol, @escaping () -> ReachabilityStatus) -> Void) {
        next(event, getState)
    }
    
    public func handle(action: ActionProtocol, getState: @escaping () -> ReachabilityStatus, next: @escaping (ActionProtocol, @escaping () -> ReachabilityStatus) -> Void) {
        next(action, getState)
    }
}
