import Foundation
import SwiftRex

public let reachabilityReducer = Reducer<ReachabilityStatus> { state, action in
    guard let reachabilityAction = action as? ReachabilityEvent else { return state }

    switch reachabilityAction {
    case .wifi, .notConfigure:
        return .reachable(viaWiFi: true)
    case .cellular:
        return .reachable(viaWiFi: false)
    case .error, .offline:
        return .unreachable
    }
}
