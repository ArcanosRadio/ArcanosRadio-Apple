import Foundation
import SwiftRex

extension Reducer where StateType == MainState {
    public static let radioPlayer = Reducer { state, action in
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
}
