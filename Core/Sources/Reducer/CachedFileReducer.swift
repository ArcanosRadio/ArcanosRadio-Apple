import Foundation
import SwiftRex

extension Reducer where StateType == [String: () -> Data] {
    public static let cachedFile = Reducer { state, action in
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
}
