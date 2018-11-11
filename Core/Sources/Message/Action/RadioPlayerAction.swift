import SwiftRex

public enum RadioPlayerAction: ActionProtocol {
    case retry
    case started
    case stopped
    case playerShouldBePlaying(Bool)
}
