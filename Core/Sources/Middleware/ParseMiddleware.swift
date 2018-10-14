import RxSwift
import SwiftRex

public final class ParseMiddleware: SideEffectMiddleware {
    public typealias StateType = Playlist?
    public var actionHandler: ActionHandler?
    public var allowEventToPropagate = true
    public var disposeBag = DisposeBag()

    public func sideEffect(for event: EventProtocol) -> AnySideEffectProducer<Playlist?>? {
        return ParseService(event: event).map(AnySideEffectProducer.init)
    }

    public init() { }
}
