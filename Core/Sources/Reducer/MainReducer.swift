import SwiftRex

public let MainReducer: () -> Reducer<MainState> = {
    return appLifeCycleReducer.lift(\.app)
//        <> navigationReducer
}
