#if os(iOS) || os(tvOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#elseif os(macOS)
import AppKit
#endif

public struct AppState: Codable, Equatable {
#if os(iOS)
    public var application: Transient<UIApplication> = .none
    public var launchOptions: Transient<[UIApplication.LaunchOptionsKey: Any?]> = .none
    public var interfaceOrientation: UIInterfaceOrientation = .unknown
    public var deviceOrientation: UIDeviceOrientation = .unknown
    public var applicationState: UIApplication.State = .inactive
    public var bounds: CGRect = .zero
    public var safeAreaInsets: UIEdgeInsets = .zero
    public var keyboardHeight: CGFloat = 0
    public var batteryMonitor: BatteryMonitor? = nil
    public var proximityMonitor: ProximityMonitor? = nil
    public var device: UIUserInterfaceIdiom = .unspecified
    public var sizeClass: SizeClass = .init()

#elseif os(watchOS)
#elseif os(tvOS)
#elseif os(macOS)
#endif

    public init() { }
}
