import SwiftRex

public enum MediaControlEvent: EventProtocol {
    case userWantsToPause
    case userWantsToResume
    case userWantsToToggle
}
