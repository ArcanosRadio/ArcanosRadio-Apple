import Foundation
import SwiftRex

public enum NavigationEvent: EventProtocol {
    case requestNavigation(Sitemap)
}

public enum NavigationAction: ActionProtocol {
    case navigationDidEnd(Sitemap)
}
