import SwiftRex

#if os(iOS) || os(tvOS)
import UIKit

public enum NavigationEvent: EventProtocol {
    case requestNavigation(Sitemap)
    case requestShareSheet(UIViewController, Either<UIView, CGRect>)
}
#elseif os(watchOS) || os(macOS)
public enum NavigationEvent: EventProtocol {
    case requestNavigation(Sitemap)
}
#endif
