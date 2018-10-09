import RxSwift
import SwiftRex

final class ParseService: SideEffectProducer {
//    var event: RepositorySearchEvent

//    init(event: RepositorySearchEvent) {
//        self.event = event
//    }

    func execute(getState: @escaping () -> MainState) -> Observable<ActionProtocol> {
        let state = getState()

        return requestStreamingServer().map { $0 as ActionProtocol }
    }
}

func requestStreamingServer() -> Observable<StreamingServerResponse> {
    return .empty()
}
