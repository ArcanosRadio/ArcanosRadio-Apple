import Foundation

public func get<A, B>(_ a: A, _ keyPath: KeyPath<A, B>) -> B {
    return a[keyPath: keyPath]
}

public func get<A, B>(_ keyPath: KeyPath<A, B>) -> (A) -> B {
    return { a in a[keyPath: keyPath] }
}

public func set<A, B>(_ keyPath: WritableKeyPath<A, B>) -> (@escaping (B) -> B) -> (A) -> A {
    return { transform in
        { a in
            set(a, keyPath, transform(a[keyPath: keyPath]))
        }
    }
}

public func set<A, B>(_ a: A, _ keyPath: WritableKeyPath<A, B>, _ value: B) -> A {
    return mset(a) {
        $0[keyPath: keyPath] = value
    }
}

public func mset<A>(_ a: A, _ transform: (inout A) -> Void) -> A {
    var mutable = a
    transform(&mutable)
    return mutable
}

public func set<A>(_ a: A, _ transform: (A) -> A) -> A {
    return map(a, transform)
}

public func map<A, B>(_ a: A, _ transform: (A) -> B) -> B {
    return transform(a)
}

public func id<T>(_ t: T) -> T {
    return t
}

public func replace<A, B>(with b: B) -> (A) -> B {
    return { _ in
        return b
    }
}

public func zip<A, B>(_ lhs: A?, _ rhs: B?) -> (A, B)? {
    switch (lhs, rhs) {
    case let (lhs?, rhs?): return (lhs, rhs)
    default: return nil
    }
}

public func curry<A, B, C>(_ fn: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in
        return { b in
            return fn(a, b)
        }
    }
}
