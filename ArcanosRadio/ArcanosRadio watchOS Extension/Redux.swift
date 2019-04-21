import Core
import Foundation
import SwiftRex
import SwiftRex_LoggerMiddleware

public let mainMiddleware: () -> ComposedMiddleware<MainState> = {
    return AppLifeCycleMiddleware(trackDeviceOrientation: true, trackBattery: true, trackProximityState: true).lift(\.app)
//        <> RouterMiddleware().lift(\.navigation)
//        <> SongUpdaterMiddleware().lift(\.currentSong)
//        <> ParseMiddleware().lift(\.currentSong)
        <> DirectLineMiddleware()
        <> LoggerMiddleware(eventFilter: { _, _ in true },
                            actionFilter: { _, _ in true },
                            debugOnly: true,
                            stateTransformer: { _ in "" })
        <> CatchErrorMiddleware { errorAction, state in
            print("Error: \(errorAction.error) on \(errorAction.message)")
            return .cauterize
    }
}

private let mainReducer: () -> Reducer<MainState> = {
    Reducer.appLifeCycle.lift(\.app)
//        <> Reducer.apiResponse
//        <> Reducer.songUpdater.lift(\.currentSong)
//        <> Reducer.cachedFile.lift(\.fileCache.value)
//        <> Reducer.navigation.lift(\.navigation)
//        <> Reducer.radioPlayer
}

extension MainStore {
    public convenience init() {
        self.init(initialState: .init(),
                  reducer: mainReducer(),
                  middleware: mainMiddleware())
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
