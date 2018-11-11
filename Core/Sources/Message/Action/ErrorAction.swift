import Foundation
import SwiftRex

public struct ErrorAction: ActionProtocol {
    public let error: Error
    public let message: Either<EventProtocol, ActionProtocol>

    public init(error: Error, message: Either<EventProtocol, ActionProtocol>) {
        self.error = error
        self.message = message
    }
}
