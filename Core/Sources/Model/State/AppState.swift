import UIKit

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

public protocol ApplicationProtocol: class {
    var isIdleTimerDisabled: Bool { get set }
}

public protocol WindowProtocol { }

#if os(iOS)
extension UIApplication: ApplicationProtocol { }
extension UIWindow: WindowProtocol { }
#endif

public enum InterfaceSizeClass: String, Codable, Equatable {
    case unspecified
    case compact
    case regular
}

public enum InterfaceOrientation: String, Codable, Equatable {
    case unknown
    case portrait
    case portraitUpsideDown
    case landscapeLeft
    case landscapeRight
}

public enum WindowActiveState: Int, Codable, Equatable {
    case inactive = 0
    case active = 1
}

public enum WindowForegroundState: Int, Codable, Equatable {
    case background = 0
    case foreground = 1
}

public struct AppState: Codable, Equatable {
    public var application: Transient<ApplicationProtocol> = .none
    public var orientation: InterfaceOrientation = .unknown
    public var windowActiveState: WindowActiveState = .active
    public var windowForegroundState: WindowForegroundState = .foreground
    public var verticalSizeClass: InterfaceSizeClass = .unspecified
    public var horizontalSizeClass: InterfaceSizeClass = .unspecified
    public var bounds: CGRect = .zero
    public var safeAreaInsets: UIEdgeInsets = .zero

    public init() { }
}
