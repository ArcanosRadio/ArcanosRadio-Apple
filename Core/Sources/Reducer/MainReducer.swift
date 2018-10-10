import SwiftRex

public let MainReducer: () -> Reducer<MainState> = {
    return appLifeCycleReducer.lift(\.app)
        <> apiResponseReducer
        <> songUpdaterReducer
//        <> navigationReducer
}
