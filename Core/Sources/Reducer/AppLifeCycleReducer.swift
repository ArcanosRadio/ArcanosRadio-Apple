import Foundation
import SwiftRex

public let appLifeCycleReducer = Reducer<AppState> { state, action in
//    guard let lifeCycleAction = action as? LifeCycleAction else { return state }
//    var stateCopy = state
//
//    switch lifeCycleAction {
//    case let .didStart(application, window, _):
//        stateCopy.application = .some(application)
//        return reduce(state: stateCopy, window: window)
//    case let .hasNewOrientation(orientation):
//        stateCopy.orientation = orientation
//        guard let window = stateCopy.application?.value?.keyWindow else { return stateCopy }
//        return reduce(state: stateCopy, window: window)
//    case let .windowActiveChanged(active):
//        stateCopy.windowActiveState = active ? .active : .inactive
//        guard let window = stateCopy.application?.value?.keyWindow else { return stateCopy }
//        return reduce(state: stateCopy, window: window)
//    case let .windowForegroundChanged(foreground):
//        stateCopy.windowForegroundState = foreground ? .foreground : .background
//        guard let window = stateCopy.application?.value?.keyWindow else { return stateCopy }
//        return reduce(state: stateCopy, window: window)
//    }
    return state
}

//private func reduce(state: AppState, window: UIWindow) -> AppState {
//    var stateCopy = state
//    stateCopy.bounds = window.bounds
//    stateCopy.horizontalSizeClass = window.traitCollection.horizontalSizeClass
//    stateCopy.verticalSizeClass = window.traitCollection.verticalSizeClass
//    stateCopy.safeAreaInsets = window.safeAreaInsets
//    return stateCopy
//}
