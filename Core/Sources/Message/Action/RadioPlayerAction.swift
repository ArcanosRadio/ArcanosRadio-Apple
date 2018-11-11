import SwiftRex

public enum RadioPlayerAction: ActionProtocol {
    case userWantsToPause
    case userWantsToResume
    case retry
    case started
    case stopped
}
