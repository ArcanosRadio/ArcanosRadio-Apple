import Foundation
import SwiftRex

extension Reducer where StateType == MainState {
    public static let apiResponse = Reducer { state, action in
        switch action {
        case let streamingServerResponse as RequestProgress<StreamingServer>:
            return set(state, \.streamingServer, streamingServerResponse)
        default:
            break
        }

        return state
    }
}
