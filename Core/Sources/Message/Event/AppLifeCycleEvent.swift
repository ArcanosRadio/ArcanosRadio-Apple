import Foundation
import SwiftRex

public protocol ApplicationProtocol: class {
    var isIdleTimerDisabled: Bool { get set }
}
public protocol WindowProtocol { }
public enum InterfaceOrientation {
    case unknown
    case portrait
    case portraitUpsideDown
    case landscapeLeft
    case landscapeRight
}

public enum AppLifeCycleEvent: EventProtocol {
    case boot(application: ApplicationProtocol,
              window: WindowProtocol,
              launchOptions: [String: Any]?)
    case rotate(window: WindowProtocol, orientation: InterfaceOrientation)
    case windowActiveChanged(window: WindowProtocol, active: Bool)
    case windowForegroundChanged(window: WindowProtocol, foreground: Bool)
}
