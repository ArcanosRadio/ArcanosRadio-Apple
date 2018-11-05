import RxSwift
import SwiftRex

public final class CachedFileMiddleware: SideEffectMiddleware {
    public typealias StateType = [String: () -> Data]
    public var actionHandler: ActionHandler?
    public var allowEventToPropagate = true
    public var disposeBag = DisposeBag()
    private var cache = NSCache<NSString, NSData>()

    public func sideEffect(for event: EventProtocol) -> AnySideEffectProducer<[String: () -> Data]>? {
        return CachedFileService(event: event, cache: cache).map(AnySideEffectProducer.init)
    }

    public init() { }
}
