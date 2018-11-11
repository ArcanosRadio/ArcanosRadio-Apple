import RxSwift
import SwiftRex

public final class CachedFileMiddleware: SideEffectMiddleware {
    public typealias StateType = [String: () -> Data]
    public var actionHandler: ActionHandler?
    public var allowEventToPropagate = true
    public var disposeBag = DisposeBag()
    private var cache = NSCache<NSString, NSData>()
    private let session: URLSession
    private let urlCache: URLCache

    public func sideEffect(for event: EventProtocol) -> AnySideEffectProducer<[String: () -> Data]>? {
        return CachedFileService(event: event, cache: cache, session: session).map(AnySideEffectProducer.init)
    }

    public init() {
        urlCache = URLCache()
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = urlCache
        configuration.requestCachePolicy = .useProtocolCachePolicy
        session = URLSession(configuration: configuration)
    }
}
