import Foundation
import SwiftRex

public let apiResponseReducer = Reducer<MainState> { state, action in
    switch action {
    case let streamingServerResponse as RequestProgress<StreamingServer>:
        return set(state, \.streamingServer, streamingServerResponse)
    default:
        break
    }

    return state
}
