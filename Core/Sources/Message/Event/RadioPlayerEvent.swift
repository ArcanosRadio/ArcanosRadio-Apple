import SwiftRex

public enum RadioPlayerEvent: EventProtocol, Equatable {
    case stopped
    case failure(Error?)
    case playing
    case paused
    case notEnoughBuffer
    case evaluatingBufferingRate
    case noItemToPlay
}

public func == (lhs: RadioPlayerEvent, rhs: RadioPlayerEvent) -> Bool {
    switch (lhs, rhs) {
    case (.stopped, .stopped): return true
    case let (.failure(lhs), .failure(rhs)): return lhs?.localizedDescription == rhs?.localizedDescription
    case (.playing, .playing): return true
    case (.paused, .paused): return true
    case (.notEnoughBuffer, .notEnoughBuffer): return true
    case (.evaluatingBufferingRate, .evaluatingBufferingRate): return true
    case (.noItemToPlay, .noItemToPlay): return true
    default: return false
    }
}

