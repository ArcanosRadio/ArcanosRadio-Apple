import RxSwift
import SwiftRex

public final class ParseMiddleware: SideEffectMiddleware {
    public typealias StateType = Playlist?
    public var actionHandler: ActionHandler?
    public var allowEventToPropagate = true
    public var subscriptionOwner = DisposeBag()
    private let session: URLSession
    private let cache: URLCache

    public func sideEffect(for event: EventProtocol) -> AnySideEffectProducer<Playlist?>? {
        return ParseService(event: event, session: session).map(AnySideEffectProducer.init)
    }

    public init() {
        cache = URLCache()
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .useProtocolCachePolicy
        session = URLSession(configuration: configuration)
    }
}
