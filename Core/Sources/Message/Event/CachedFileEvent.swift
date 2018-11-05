import SwiftRex

public enum CachedFileEvent: EventProtocol {
    case fileRequested(url: URL)
}
