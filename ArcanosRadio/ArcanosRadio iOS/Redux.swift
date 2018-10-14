import Core
import Foundation
import SwiftRex

public let MainMiddleware: () -> ComposedMiddleware<MainState> = {
    return // LoggerMiddleware()
           AppLifeCycleMiddleware(trackDeviceOrientation: true, trackBattery: true, trackProximityState: true).lift(\.app)
        <> RouterMiddleware()
        <> SongUpdaterMiddleware().lift(\.currentSong)
        <> ParseMiddleware().lift(\.currentSong)
        <> DirectLineMiddleware()
        <> CatchErrorMiddleware { errorAction, state in
               print("Error: \(errorAction.error) on \(errorAction.message)")
               return .cauterize
           }
}

public let MainReducer: () -> Reducer<MainState> = {
    return appLifeCycleReducer.lift(\.app)
        <> apiResponseReducer
        <> songUpdaterReducer.lift(\.currentSong)
    //        <> navigationReducer
}

extension MainStore {
    public static let shared = MainStore()
    
    public convenience init() {
        self.init(initialState: .init(),
                  reducer: MainReducer(),
                  middleware: MainMiddleware())
    }
}

extension HasStateProvider {
    var stateProvider: MainStateProvider {
        return MainStore.shared
    }
}

extension HasEventHandler {
    var eventHandler: EventHandler {
        return MainStore.shared
    }
}
