import Foundation
import SwiftRex

public enum Either<A, B> {
    case left(A)
    case right(B)
}

public struct ErrorAction: ActionProtocol {
    public let error: Error
    public let message: Either<EventProtocol, ActionProtocol>

    public init(error: Error, message: Either<EventProtocol, ActionProtocol>) {
        self.error = error
        self.message = message
    }
}
