// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
    import AppKit.NSColor
    internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIColor
    internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

extension Color {
    // swiftlint:disable identifier_name line_length type_body_length
    internal struct ColorName {
        internal let rgbaValue: UInt32
        internal var color: Color { return Color(rgbaValue: rgbaValue) }

        /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
        /// Alpha: 100% <br/> (0xffffffff)
        internal static let bodyBackground = ColorName(rgbaValue: 0xffffffff)
        /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
        /// Alpha: 100% <br/> (0x000000ff)
        internal static let bodyText = ColorName(rgbaValue: 0x000000ff)
        /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
        /// Alpha: 100% <br/> (0x000000ff)
        internal static let bodyTint = ColorName(rgbaValue: 0x000000ff)
    }
    // swiftlint:enable identifier_name line_length type_body_length
}

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
    convenience init(rgbaValue: UInt32) {
        let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
        let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
        let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
        let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
    static func named(_ colorName: ColorName) -> UIColor {
        return colorName.color
    }
}
