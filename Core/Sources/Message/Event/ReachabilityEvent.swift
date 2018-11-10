import SwiftRex

public enum ReachabilityEvent: EventProtocol, ActionProtocol {
    case wifi
    case cellular
    case offline
    case notConfigure
    case error(Error)
}
