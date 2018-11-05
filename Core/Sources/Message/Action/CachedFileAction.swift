import SwiftRex

public enum CachedFileAction: ActionProtocol {
    case downloading(url: URL)
    case fileNotFound(url: URL)
    case fileAvailable(url: URL, data: () -> Data)
}
