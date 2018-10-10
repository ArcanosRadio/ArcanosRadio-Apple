import Foundation
import SwiftRex

public enum AppLifeCycleEvent: EventProtocol {
    case boot(application: ApplicationProtocol,
              launchOptions: [String: Any]?)
    case rotate(window: WindowProtocol, orientation: InterfaceOrientation)
    case windowActiveChanged(window: WindowProtocol, active: Bool)
    case windowForegroundChanged(window: WindowProtocol, foreground: Bool)
}
