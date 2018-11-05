import Foundation
import SwiftRex

public let cachedFileReducer = Reducer<[String: () -> Data]> { state, action in
    guard let cachedFileAction = action as? CachedFileAction else { return state }

    var stateCopy = state

    switch cachedFileAction {
    case let .downloading(url):
        stateCopy[url.absoluteString] = nil
    case let .fileNotFound(url):
        stateCopy[url.absoluteString] = nil
    case let .fileAvailable(url, getter):
        stateCopy[url.absoluteString] = getter
    }

    return stateCopy
}
