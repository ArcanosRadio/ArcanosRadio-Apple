import RxSwift
import SwiftRex

final class ParseService: SideEffectProducer {
//    var event: RepositorySearchEvent

//    init(event: RepositorySearchEvent) {
//        self.event = event
//    }

    func execute(getState: @escaping () -> MainState) -> Observable<ActionProtocol> {
        let state = getState()

        return .empty()
    }

//    func loadFirstPage(_ query: String?, _ state: GlobalState) -> Observable<RepositorySearchAction> {
//        state.lastSearch.possibleTask()?.cancel()
//
//        let setQuery = Observable.just(RepositorySearchAction.setQuery(query))
//        guard let pageUrl = url(for: query, page: 1) else { return setQuery }
//
//        return Observable.concat(
//            setQuery,
//            loadPage(pageUrl: pageUrl,
//                     transform: { $0.map(RepositorySearchAction.gotFirstPage,
//                                         RepositorySearchAction.gotError) })
//        )
//    }
//
//    func loadNextPage(_ state: GlobalState) -> Observable<RepositorySearchAction> {
//        guard state.lastSearch.possibleTask() == nil,
//            let pageUrl = state.nextPage else {
//                return .empty()
//        }
//
//        return loadPage(pageUrl: pageUrl,
//                        transform: { $0.map(RepositorySearchAction.gotNextPage,
//                                            RepositorySearchAction.gotError) })
//    }
//
//    private func loadPage(pageUrl: URL,
//                          transform: @escaping (Result<(repositories: [Repository], nextURL: URL?)>)
//        throws -> RepositorySearchAction) -> Observable<RepositorySearchAction> {
//        let task = ObservableCancelable()
//
//        return Observable.concat(
//            .just(RepositorySearchAction.startedSearch(task: task)),
//
//            service
//                .loadSearchURL(pageUrl)
//                .takeUntil(task.filter { $0 })
//                .catchError { .just(.failure($0)) }
//                .map(transform)
//        )
//    }

//    private func url(for query: String?, page: Int) -> URL? {
//        guard let query = query, !query.isEmpty else { return nil }
//        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
//    }
}
