import Foundation
import UIKit

#if os(iOS)
extension UIInterfaceOrientation: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        case .unknown: return "unknown"
        @unknown default: return "unknown"
        }
    }
}

extension UIDeviceOrientation: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .faceDown: return "faceDown"
        case .faceUp: return "faceUp"
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        case .unknown: return "unknown"
        @unknown default: return "unknown"
        }
    }
}

extension UIDevice.BatteryState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .charging: return "charging"
        case .full: return "full"
        case .unknown: return "unknown"
        case .unplugged: return "unplugged"
        @unknown default: return "unknown"
        }
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

extension UIInterfaceOrientation: Codable, Equatable { }
extension UIDeviceOrientation: Codable { }
extension UIDevice.BatteryState: Codable { }
#endif

extension UIUserInterfaceSizeClass: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .compact: return "compact"
        case .regular: return "regular"
        case .unspecified: return "unspecified"
        @unknown default: return "unknown"
        }
    }
}

extension UIApplication.State: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .active: return "active"
        case .background: return "background"
        case .inactive: return "inactive"
        @unknown default: return "unknown"
        }
    }
}

extension UIUserInterfaceIdiom: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .carPlay: return "carPlay"
        case .pad: return "iPad"
        case .phone: return "iPhone"
        case .tv: return "Apple TV"
        case .unspecified: return "Unspecified"
        @unknown default: return "unknown"
        }
    }
}

extension UIUserInterfaceSizeClass: Codable, Equatable { }
extension UIApplication.State: Codable, Equatable { }
extension UIUserInterfaceIdiom: Codable { }

public struct SizeClass: Codable, Equatable {
    public let vertical: UIUserInterfaceSizeClass
    public let horizontal: UIUserInterfaceSizeClass

    public init(horizontal: UIUserInterfaceSizeClass = .unspecified, vertical: UIUserInterfaceSizeClass = .unspecified) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}
