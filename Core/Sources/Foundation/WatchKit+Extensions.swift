import Foundation
import WatchKit

extension WKApplicationState: CustomDebugStringConvertible, Codable {
    public var debugDescription: String {
        switch self {
        case .active: return "active"
        case .inactive: return "inactive"
        case .background: return "background"
        }
    }
}

extension WKInterfaceDeviceBatteryState: CustomDebugStringConvertible, Codable {
    public var debugDescription: String {
        switch self {
        case .unknown: return "unknown"
        case .unplugged: return "unplugged"
        case .charging: return "charging"
        case .full: return "full"
        }
    }
}

extension WKInterfaceDeviceCrownOrientation: CustomDebugStringConvertible, Codable {
    public var debugDescription: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        }
    }
}

extension WKInterfaceLayoutDirection: CustomDebugStringConvertible, Codable {
    public var debugDescription: String {
        switch self {
        case .leftToRight: return "leftToRight"
        case .rightToLeft: return "rightToLeft"
        }
    }
}

extension WKWaterResistanceRating: CustomDebugStringConvertible, Codable {
    public var debugDescription: String {
        switch self {
        case .ipx7: return "ipx7"
        case .wr50: return "wr50"
        }
    }
}

extension WKInterfaceDeviceWristLocation: CustomDebugStringConvertible, Codable {
    public var debugDescription: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        }
    }
}
