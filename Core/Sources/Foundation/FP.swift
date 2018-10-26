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
