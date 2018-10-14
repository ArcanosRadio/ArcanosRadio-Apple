/// Wraps a value but causes it to be treated as "value-less" for the purposes
/// of automatic Equatable, Hashable, and Codable synthesis. This allows one to
/// declare a "cache"-like property in a value type without giving up the rest
/// of the benefits of synthesis.
public enum Transient<Wrapped>: Equatable, Hashable, Codable {

    case none
    case some(Wrapped)

    public static func == (lhs: Transient<Wrapped>, rhs: Transient<Wrapped>) -> Bool {
        // By always returning true, transient values never produce false negatives
        // that cause two otherwise equal values to become unequal. In other words,
        // they are ignored for the purposes of equality.
        return true
    }

    public var hashValue: Int {
        // Transient values do not contribute to the hash value. (This could be any
        // constant.)
        return 0
    }

    public init(from decoder: Decoder) {
        // Since the value is transient, it's not encoded, so at decode-time we
        // merely clear it.
        self = .none
    }

    public func encode(to encoder: Encoder) throws {
        // Transient properties do not get encoded.
    }

    public var value: Wrapped? {
        get {
            if case let .some(wrapped) = self {
                return wrapped
            }

            return nil
        }
        set {
            self = newValue.map(Transient.some) ?? .none
        }
    }
}
