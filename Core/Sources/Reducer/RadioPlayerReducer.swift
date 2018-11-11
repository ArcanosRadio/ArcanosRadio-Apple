import Foundation
import SwiftRex

public let radioPlayerReducer = Reducer<MainState> { state, action in
    guard let radioPlayerAction = action as? RadioPlayerAction else { return state }

    switch radioPlayerAction {

    case let .playerShouldBePlaying(userChoice):
        return set(state, \.userWantsToListen, userChoice)
    case .retry:
        return state
    case .started:
        return set(state, \.isPlaying, true)
    case .stopped:
        return set(state, \.isPlaying, false)
    }
}
