import Foundation
import RxSwift
import SwiftRex

public protocol MainStateProvider {
    func map<B>(_ transform: @escaping (MainState) throws -> B) rethrows -> Observable<B>
    func map<B>(_ keyPath: KeyPath<MainState, B>) -> Observable<B>
    subscript<B>(_ keyPath: KeyPath<MainState, B>) -> Observable<B> { get }
    func subscribe(if condition: @escaping (MainState?, MainState) -> Bool,
                   _ handler: @escaping (MainState) -> Void) -> Disposable
    func subscribe(_ handler: @escaping (MainState) -> Void) -> Disposable
}

extension MainStore: MainStateProvider {
    public func subscribe(_ handler: @escaping (MainState) -> Void) -> Disposable {
        return subscribe(onNext: handler, onError: nil, onCompleted: nil, onDisposed: nil)
    }

    public func map<B>(_ keyPath: KeyPath<MainState, B>) -> Observable<B> {
        return map { observable in observable[keyPath: keyPath] }
    }

    public subscript<B>(keyPath: KeyPath<MainState, B>) -> Observable<B> {
        return map(keyPath)
    }

    public func subscribe(if condition: @escaping (MainState?, MainState) -> Bool,
                          _ handler: @escaping (MainState) -> Void) -> Disposable {
        return
            scan((MainState?.none, MainState?.none)) { previous, newValue in
                return (previous.1, newValue)
            }.filter { pair in
                condition(pair.0, pair.1!)
            }.map {
                $0.1!
            }.subscribe(onNext: handler, onError: nil, onCompleted: nil, onDisposed: nil)
    }
}

public protocol HasStateProvider {
    var stateProvider: MainStateProvider { get }
}

public protocol HasEventHandler {
    var eventHandler: EventHandler { get }
}
