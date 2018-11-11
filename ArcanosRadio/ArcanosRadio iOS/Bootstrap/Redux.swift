import Core
import Foundation
import SwiftRex

public let MainMiddleware: () -> ComposedMiddleware<MainState> = {
    return AppLifeCycleMiddleware(trackDeviceOrientation: true, trackBattery: true, trackProximityState: true).lift(\.app)
        <> RouterMiddleware().lift(\.navigation)
        <> SongUpdaterMiddleware().lift(\.currentSong)
        <> CachedFileMiddleware().lift(\.fileCache.value)
        <> ParseMiddleware().lift(\.currentSong)
        <> RadioPlayerMiddleware()
        <> DirectLineMiddleware()
        <> LoggerMiddleware(eventFilter: { _, event in event is ReachabilityEvent },
                            actionFilter: { _, _ in false },
                            debugOnly: true,
                            stateTransformer: { _ in "" })
        <> CatchErrorMiddleware { errorAction, state in
               print("Error: \(errorAction.error) on \(errorAction.message)")
               return .cauterize
           }
        <> ReachabilityMiddleware().lift(\.connectionState)
}

public let MainReducer: () -> Reducer<MainState> = {
    return appLifeCycleReducer.lift(\.app)
        <> apiResponseReducer
        <> songUpdaterReducer.lift(\.currentSong)
        <> cachedFileReducer.lift(\.fileCache.value)
        <> navigationReducer.lift(\.navigation)
        <> reachabilityReducer.lift(\.connectionState)
        <> radioPlayerReducer
}

extension MainStore {
    public convenience init() {
        self.init(initialState: .init(),
                  reducer: MainReducer(),
                  middleware: MainMiddleware())
    }
}

extension HasStateProvider {
    var stateProvider: MainStateProvider {
        return inject(MainStateProvider.self)
    }
}

extension HasEventHandler {
    var eventHandler: EventHandler {
        return inject(EventHandler.self)
    }
}
