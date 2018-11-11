import RxCocoa
import RxSwift
import SwiftRex

final class CachedFileService: SideEffectProducer {
    var url: URL
    private var cache = NSCache<NSString, NSData>()
    private let session: URLSession

    init?(event: EventProtocol, cache: NSCache<NSString, NSData>, session: URLSession) {
        guard let cachedFileEvent = event as? CachedFileEvent else { return nil }

        self.cache = cache
        self.session = session

        switch cachedFileEvent {
        case let .fileRequested(url):
            self.url = url
        }
    }

    func execute(getState: @escaping () -> [String: () -> Data]) -> Observable<ActionProtocol> {
        return cachedOrDownload(url: url, cache: cache, session: session).map { $0 as ActionProtocol }
    }
}

func cachedOrDownload(url: URL, cache: NSCache<NSString, NSData>, session: URLSession) -> Observable<CachedFileAction> {
    let absoluteUrl = url.absoluteString as NSString

    if cache.object(forKey: absoluteUrl) as Data? != nil {
        return .just(.fileAvailable(url: url, data: { cache.object(forKey: absoluteUrl)! as Data }))
    }

    let downloadTask = session.rx
        .data(request: URLRequest(url: url))
        .observeOn(MainScheduler.instance)
        .do(
            onNext: { data in
                cache.setObject(data as NSData, forKey: absoluteUrl)
            },
            onError: { _ in
                cache.removeObject(forKey: absoluteUrl)
            })
        .map { data in
            .fileAvailable(url: url, data: { cache.object(forKey: absoluteUrl)! as Data })
        }.catchErrorJustReturn(CachedFileAction.fileNotFound(url: url))

    return Observable.concat(
        .just(CachedFileAction.downloading(url: url)),
        downloadTask
    )
}
