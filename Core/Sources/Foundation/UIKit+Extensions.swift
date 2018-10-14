import Foundation
import UIKit

extension UIInterfaceOrientation: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        case .unknown: return "unknown"
        }
    }
}

extension UIUserInterfaceSizeClass: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .compact: return "compact"
        case .regular: return "regular"
        case .unspecified: return "unspecified"
        }
    }
}

extension UIApplication.State: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .active: return "active"
        case .background: return "background"
        case .inactive: return "inactive"
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
        }
    }
}

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
