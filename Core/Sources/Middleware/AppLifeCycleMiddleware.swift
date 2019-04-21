import Foundation
import RxSwift
import SwiftRex

public final class AppLifeCycleMiddleware: Middleware {
    public var actionHandler: ActionHandler?
    private var eventHandler: EventHandler? {
        return actionHandler as? EventHandler
    }
    private let disposeBag = DisposeBag()

    public func handle(event: EventProtocol, getState: @escaping () -> AppState, next: @escaping (EventProtocol, @escaping () -> AppState) -> Void) {
        next(event, getState)
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> AppState, next: @escaping (ActionProtocol, @escaping () -> AppState) -> Void) {
        next(action, getState)
    }

    public init(trackDeviceOrientation: Bool = false, trackBattery: Bool = false, trackProximityState: Bool = false) {
        bind(trackDeviceOrientation: trackDeviceOrientation, trackBattery: trackBattery, trackProximityState: trackProximityState)
    }
}

#if os(iOS)
import UIKit

extension AppLifeCycleMiddleware {
    private func bind(trackDeviceOrientation: Bool, trackBattery: Bool, trackProximityState: Bool) {
        Observable
            .from([
                NotificationCenter.default.rx
                    .notification(UIResponder.keyboardWillChangeFrameNotification)
                    .map { notification in
                        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                    },
                NotificationCenter.default.rx
                    .notification(UIResponder.keyboardWillHideNotification)
                    .map { _ in 0 }
            ]).merge()
            .subscribe(onNext: { [weak self] keyboardHeight in
                self?.actionHandler?.trigger(AppLifeCycleEvent.keyboardToggle(height: keyboardHeight))
            }).disposed(by: disposeBag)

        Observable
            .from([
                NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).map { _ in },
                NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification).map { _ in },
                NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).map { _ in },
                NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification).map { _ in }
            ]).merge()
            .subscribe(onNext: { [weak self] _ in
                self?.actionHandler?.trigger(AppLifeCycleEvent.applicationStateDidChange)
            }).disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIWindow.didBecomeKeyNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let disposeBag = self?.disposeBag else { return }
                guard let window = notification.object as? UIWindow else { return }

                self?.actionHandler?.trigger(AppLifeCycleEvent.keyWindowSet(window))

                window.rx
                    .observeWeakly(CGRect.self, "frame")
                    .distinctUntilChanged()
                    .subscribe(onNext: { frame in
                        self?.actionHandler?.trigger(AppLifeCycleEvent.didChangeBounds)
                    }).disposed(by: disposeBag)
            }).disposed(by: disposeBag)

        if trackDeviceOrientation {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.rx
                .notification(UIDevice.orientationDidChangeNotification)
                .map { ($0.object as! UIDevice).orientation }
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] orientation in
                    self?.actionHandler?.trigger(AppLifeCycleEvent.didRotateDevice)
                }).disposed(by: disposeBag)
        }

        if trackProximityState {
            UIDevice.current.isProximityMonitoringEnabled = true
            NotificationCenter.default.rx
                .notification(UIDevice.proximityStateDidChangeNotification)
                .subscribe(onNext: { [weak self] _ in
                    self?.actionHandler?.trigger(AppLifeCycleEvent.proximityStateDidChange)
                }).disposed(by: disposeBag)
        }

        if trackBattery {
            UIDevice.current.isBatteryMonitoringEnabled = true
            NotificationCenter.default.rx
                .notification(UIDevice.batteryLevelDidChangeNotification)
                .map { ($0.object as! UIDevice).batteryLevel }
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] _ in
                    self?.actionHandler?.trigger(AppLifeCycleEvent.didChangeBatteryLevel)
                }).disposed(by: disposeBag)
        }

        NotificationCenter.default.rx
            .notification(UIApplication.didFinishLaunchingNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let application = notification.object as? UIApplication else { return }

                let launchOptions = notification.userInfo.flatMap {
                    $0.reduce([UIApplication.LaunchOptionsKey: Any]()) { partial, keyValue in
                        var result = partial
                        if let launchOptionsKey = keyValue.key as? UIApplication.LaunchOptionsKey {
                            result[launchOptionsKey] = keyValue.value
                        }
                        return result
                    }
                }

                self?.eventHandler?.dispatch(AppLifeCycleEvent.boot(application: application, launchOptions: launchOptions))
            }).disposed(by: disposeBag)
    }
}

#elseif os(watchOS)
import WatchKit

extension AppLifeCycleMiddleware {
    private func bind(trackDeviceOrientation: Bool, trackBattery: Bool, trackProximityState: Bool) {

        let autorotated: Observable<Void>?
        if #available(watchOS 4.2, *) {
            autorotated = WKExtension.shared().rx.observeWeakly(Bool.self, "autorotated").map { _ in () }
        } else {
            autorotated = nil
        }

        Observable
            .from([
                WKExtension.shared().rx.observeWeakly(WKApplicationState.self, "applicationState").map { _ in () },
                WKExtension.shared().rx.observeWeakly(Bool.self, "frontmostTimeoutExtended").map { _ in () },
                WKExtension.shared().rx.observeWeakly(Bool.self, "isApplicationRunningInDock").map { _ in () },
                WKExtension.shared().rx.observeWeakly(Bool.self, "autorotating").map { _ in () },
                autorotated
                ].compactMap(id)
            ).merge()
            .subscribe(onNext: { [weak self] _ in
                self?.actionHandler?.trigger(AppLifeCycleEvent.applicationStateDidChange)
            }).disposed(by: disposeBag)

        if trackBattery {
            WKInterfaceDevice.current().isBatteryMonitoringEnabled = true

            WKInterfaceDevice.current().rx
                .observeWeakly(Float.self, "batteryLevel")
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] _ in
                    self?.actionHandler?.trigger(AppLifeCycleEvent.didChangeBatteryLevel)
                }).disposed(by: disposeBag)
        }
    }
}

#elseif os(tvOS)
import UIKit

extension AppLifeCycleMiddleware {
    private func bind(trackDeviceOrientation: Bool, trackBattery: Bool, trackProximityState: Bool) {
        Observable
            .from([
                NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).map { _ in },
                NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification).map { _ in },
                NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).map { _ in },
                NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification).map { _ in }
                ]).merge()
            .subscribe(onNext: { [weak self] _ in
                self?.actionHandler?.trigger(AppLifeCycleEvent.applicationStateDidChange)
            }).disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIWindow.didBecomeKeyNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let disposeBag = self?.disposeBag else { return }
                guard let window = notification.object as? UIWindow else { return }

                self?.actionHandler?.trigger(AppLifeCycleEvent.keyWindowSet(window))

                window.rx
                    .observeWeakly(CGRect.self, "frame")
                    .distinctUntilChanged()
                    .subscribe(onNext: { frame in
                        self?.actionHandler?.trigger(AppLifeCycleEvent.didChangeBounds)
                    }).disposed(by: disposeBag)
            }).disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIApplication.didFinishLaunchingNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let application = notification.object as? UIApplication else { return }

                let launchOptions = notification.userInfo.flatMap {
                    $0.reduce([UIApplication.LaunchOptionsKey: Any]()) { partial, keyValue in
                        var result = partial
                        if let launchOptionsKey = keyValue.key as? UIApplication.LaunchOptionsKey {
                            result[launchOptionsKey] = keyValue.value
                        }
                        return result
                    }
                }

                self?.eventHandler?.dispatch(AppLifeCycleEvent.boot(application: application, launchOptions: launchOptions))
            }).disposed(by: disposeBag)
    }
}

#elseif os(macOS)
import AppKit

extension AppLifeCycleMiddleware {
    private func bind(trackDeviceOrientation: Bool, trackBattery: Bool, trackProximityState: Bool) { }
}
#endif
