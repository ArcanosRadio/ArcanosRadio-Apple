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
    public var application: Transient<WKExtension> = .none
    public var applicationState: WKApplicationState = .inactive
    public var isApplicationRunningInDock: Bool = false
    public var isAutorotated: Bool = false
    public var isAutorotating: Bool = false
    public var isFrontmostTimeoutExtended: Bool = false
    public var batteryLevel: Float = -1.0
    public var batteryState: WKInterfaceDeviceBatteryState = .unknown
    public var crownOrientation: WKInterfaceDeviceCrownOrientation = .left
    public var isBatteryMonitoringEnabled: Bool = false
    public var layoutDirection: WKInterfaceLayoutDirection = .leftToRight
    public var localizedModel: String = ""
    public var model: String = ""
    public var name: String = ""
    public var preferredContentSizeCategory: String = ""
    public var screenBounds: CGRect = .zero
    public var screenScale: CGFloat = -1.0
    public var systemName: String = ""
    public var systemVersion: String = ""
    public var waterResistanceRating: WKWaterResistanceRating = .ipx7
    public var wristLocation: WKInterfaceDeviceWristLocation = .left

#elseif os(tvOS)
    public var application: Transient<UIApplication> = .none
    public var launchOptions: Transient<[UIApplication.LaunchOptionsKey: Any?]> = .none
    public var applicationState: UIApplication.State = .inactive
    public var bounds: CGRect = .zero
    public var safeAreaInsets: UIEdgeInsets = .zero
    public var keyboardHeight: CGFloat = 0
    public var device: UIUserInterfaceIdiom = .unspecified

    #elseif os(macOS)
#endif

    public init() { }
}
