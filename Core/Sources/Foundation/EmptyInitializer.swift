import Foundation

public protocol EmptyInitializer {
    init()
}

extension Optional: EmptyInitializer {
    public init() {
        self = .none
    }
}

extension Array: EmptyInitializer { }
extension String: EmptyInitializer { }
extension Dictionary: EmptyInitializer { }
extension Bool: EmptyInitializer { }
extension UInt8: EmptyInitializer { }
extension Int8: EmptyInitializer { }
extension UInt16: EmptyInitializer { }
extension Int16: EmptyInitializer { }
extension UInt32: EmptyInitializer { }
extension Int32: EmptyInitializer { }
extension UInt64: EmptyInitializer { }
extension Int64: EmptyInitializer { }
extension UInt: EmptyInitializer { }
extension Int: EmptyInitializer { }
extension Float: EmptyInitializer { }
extension CGFloat: EmptyInitializer { }
extension Double: EmptyInitializer { }
extension Decimal: EmptyInitializer { }
extension CGSize: EmptyInitializer { }
extension CGRect: EmptyInitializer { }
