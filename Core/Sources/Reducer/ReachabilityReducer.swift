import Foundation
import SwiftRex

public let reachabilityReducer = Reducer<Reachability.Connection> { state, action in
    guard let reachabilityAction = action as? ReachabilityEvent else { return state }

    switch reachabilityAction {
    case .wifi, .notConfigure:
        return .wifi
    case .cellular:
        return .cellular
    case .error, .offline:
        return .none
    }
}
