import Core
import Foundation
import SwiftRex

public let MainMiddleware: () -> ComposedMiddleware<MainState> = {
    return AppLifeCycleMiddleware(trackDeviceOrientation: false, trackBattery: false, trackProximityState: false).lift(\.app)
        <> RouterMiddleware().lift(\.navigation)
        <> SongUpdaterMiddleware()
        <> MediaRemoteControlMiddleware()
        <> CachedFileMiddleware().lift(\.fileCache.value)
        <> ParseMiddleware().lift(\.currentSong)
        <> RadioPlayerMiddleware()
        <> DirectLineMiddleware()
        <> LoggerMiddleware(eventFilter: { _, ev in !(ev is RefreshTimerEvent) },
                            actionFilter: { _, ac in !(ac is RequestProgress<Playlist>) },
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
