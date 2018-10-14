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
