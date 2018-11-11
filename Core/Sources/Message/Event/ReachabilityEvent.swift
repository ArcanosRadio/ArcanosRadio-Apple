import SwiftRex

public enum ReachabilityEvent: EventProtocol, ActionProtocol, Equatable {
    case wifi
    case cellular
    case offline
    case notConfigure
    case error(Error)
}

public func == (lhs: ReachabilityEvent, rhs: ReachabilityEvent) -> Bool {
    switch (lhs, rhs) {
    case (.wifi, .wifi): return true
    case (.cellular, .cellular): return true
    case (.offline, .offline): return true
    case (.notConfigure, .notConfigure): return true
    case let (.error(lhs), .error(rhs)): return lhs.localizedDescription == rhs.localizedDescription
    default: return false
    }
}
