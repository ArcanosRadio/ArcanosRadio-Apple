import Foundation
import SwiftRex

public let radioPlayerReducer = Reducer<MainState> { state, action in
    guard let radioPlayerAction = action as? RadioPlayerAction else { return state }

    switch radioPlayerAction {

    case .userWantsToPause:
        return set(state, \.userWantsToListen, false)
    case .userWantsToResume:
        return set(state, \.userWantsToListen, true)
    case .retry:
        return state
    case .started:
        return set(state, \.isPlaying, true)
    case .stopped:
        return set(state, \.isPlaying, false)
    }
}
