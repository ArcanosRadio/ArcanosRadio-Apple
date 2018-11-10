import Foundation
import SwiftRex

public enum NavigationEvent: EventProtocol {
    case requestNavigation(Sitemap)
}
