import Foundation
import RxSwift
import SwiftRex

public enum PropagateErrorAction {
    case propagate
    case cauterize
    case transform(ActionProtocol)
}

public class CatchErrorMiddleware<StateType>: Middleware {
    public init(handler: @escaping (ErrorAction, StateType) -> PropagateErrorAction) {
        self.errorHandler = handler
    }

    public var actionHandler: ActionHandler?
    private let disposeBag = DisposeBag()
    private let errorHandler: (ErrorAction, StateType) -> PropagateErrorAction

    public func handle(event: EventProtocol, getState: @escaping () -> StateType, next: @escaping (EventProtocol, @escaping () -> StateType) -> Void) {
        next(event, getState)
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> StateType, next: @escaping (ActionProtocol, @escaping () -> StateType) -> Void) {
        guard let errorAction = action as? ErrorAction else {
            next(action, getState)
            return
        }

        handle(errorAction: errorAction, getState: getState, next: next)
    }

    private func handle(errorAction: ErrorAction, getState: @escaping () -> StateType, next: @escaping (ActionProtocol, @escaping () -> StateType) -> Void) {
        switch errorHandler(errorAction, getState()) {
        case .propagate:
            next(errorAction, getState)
        case let .transform(transformedAction):
            next(transformedAction, getState)
        case .cauterize:
            break
        }
    }
}
