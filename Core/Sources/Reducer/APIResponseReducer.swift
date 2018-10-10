import Foundation
import SwiftRex

public let apiResponseReducer = Reducer<MainState> { state, action in
    switch action {
    case let streamingServerResponse as RequestProgress<StreamingServer>:
        var stateCopy = state
        stateCopy.streamingServer = streamingServerResponse
        return stateCopy
    default:
        break
    }

    return state
}
