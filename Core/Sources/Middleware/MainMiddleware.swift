import Foundation
import SwiftRex

public let MainMiddleware: () -> ComposedMiddleware<MainState> = {
    return LoggerMiddleware()
        <> LifeCycleMiddleware()
        <> RouterMiddleware()
        <> SongUpdaterMiddleware()
        <> ParseMiddleware()
        <> CatchErrorMiddleware { errorAction, state in
               print("Error: \(errorAction.error) on \(errorAction.message)")
               return .cauterize
           }
}
