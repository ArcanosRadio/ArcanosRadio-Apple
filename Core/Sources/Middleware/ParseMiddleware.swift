import RxSwift
import SwiftRex

public final class ParseMiddleware: SideEffectMiddleware {
    public typealias StateType = MainState
    public var actionHandler: ActionHandler?
    public var allowEventToPropagate = false
    public var disposeBag = DisposeBag()

    public func sideEffect(for event: EventProtocol) -> AnySideEffectProducer<MainState>? {
        return nil // AnySideEffectProducer(ParseService(event: event))
    }
}
