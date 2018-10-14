#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#elseif os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if os(iOS)
extension UIInterfaceOrientation: Codable, Equatable { }
extension UIUserInterfaceSizeClass: Codable, Equatable { }
extension UIApplication.State: Codable, Equatable { }
extension UIDeviceOrientation: Codable { }
extension UIDevice.BatteryState: Codable { }
extension UIUserInterfaceIdiom: Codable { }

extension UIEdgeInsets: Codable {
    enum CodingKeys: CodingKey {
        case top, left, bottom, right
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let topValue = try container.decode(CGFloat.self, forKey: .top)
        let leftValue = try container.decode(CGFloat.self, forKey: .left)
        let bottomValue = try container.decode(CGFloat.self, forKey: .bottom)
        let rightValue = try container.decode(CGFloat.self, forKey: .right)
        self.init(top: topValue, left: leftValue, bottom: bottomValue, right: rightValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(top, forKey: .top)
        try container.encode(left, forKey: .left)
        try container.encode(bottom, forKey: .bottom)
        try container.encode(right, forKey: .right)
    }
}

public struct BatteryMonitor: Codable, Equatable {
    public let level: Float
    public let state: UIDevice.BatteryState

    public init(level: Float, state: UIDevice.BatteryState) {
        self.level = level
        self.state = state
    }
}

public struct ProximityMonitor: Codable, Equatable {
    public let isNear: Bool

    public init(isNear: Bool) {
        self.isNear = isNear
    }
}

public struct SizeClass: Codable, Equatable {
    public let vertical: UIUserInterfaceSizeClass
    public let horizontal: UIUserInterfaceSizeClass

    public init(horizontal: UIUserInterfaceSizeClass = .unspecified, vertical: UIUserInterfaceSizeClass = .unspecified) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}
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
