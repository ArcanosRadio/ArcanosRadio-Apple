import Core
import Foundation
import SwiftRex

public let MainMiddleware: () -> ComposedMiddleware<MainState> = {
    return AppLifeCycleMiddleware(trackDeviceOrientation: true, trackBattery: true, trackProximityState: true).lift(\.app)
        <> RouterMiddleware().lift(\.navigation)
        <> SongUpdaterMiddleware().lift(\.currentSong)
        <> ParseMiddleware().lift(\.currentSong)
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

public let MainReducer: () -> Reducer<MainState> = {
    return appLifeCycleReducer.lift(\.app)
        <> apiResponseReducer
        <> songUpdaterReducer.lift(\.currentSong)
        <> navigationReducer.lift(\.navigation)
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
