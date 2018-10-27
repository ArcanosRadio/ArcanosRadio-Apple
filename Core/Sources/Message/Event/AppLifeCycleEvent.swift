import Foundation
import SwiftRex

#if os(iOS)
import UIKit

public enum AppLifeCycleEvent {
    case boot(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    case keyWindowSet(UIWindow)
    case applicationStateDidChange
    case didChangeBounds
    case didRotateDevice
    case didChangeBatteryLevel
    case proximityStateDidChange
    case keyboardToggle(height: CGFloat)
}

#elseif os(watchOS)
import WatchKit

public enum AppLifeCycleEvent {
    case boot
    case applicationStateDidChange
    case didChangeBatteryLevel
}

#elseif os(tvOS)
public enum AppLifeCycleEvent {
    case boot(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    case keyWindowSet(UIWindow)
    case applicationStateDidChange
    case didChangeBounds
}

#elseif os(macOS)
import AppKit

public enum AppLifeCycleEvent {
    case boot
}
#endif

extension AppLifeCycleEvent: EventProtocol, ActionProtocol { }
