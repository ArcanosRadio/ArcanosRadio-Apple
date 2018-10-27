import Foundation
import SwiftRex

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#elseif os(macOS)
import AppKit
#endif

public let appLifeCycleReducer = Reducer<AppState> { state, action in
    guard let lifeCycleAction = action as? AppLifeCycleEvent else { return state }

    #if os(iOS)
    switch lifeCycleAction {
    case let .boot(application, launchOptions):
        return mset(state) {
            $0.application = .some(application)
            $0.launchOptions = launchOptions.map(Transient.some) ?? . none
            $0.device = UIDevice.current.userInterfaceIdiom
            $0 = boundsReducer(state: $0)
        }

    case .applicationStateDidChange:
        return mset(state) {
            $0.applicationState = $0.application.value?.applicationState ?? .background
            $0 = boundsReducer(state: $0)
        }

    case let .keyboardToggle(height):
        return mset(state) {
            $0.keyboardHeight = height
            $0 = boundsReducer(state: $0)
        }

    case .didChangeBatteryLevel:
        return mset(state) {
            $0.batteryMonitor = UIDevice.current.isBatteryMonitoringEnabled
                ? .init(level: UIDevice.current.batteryLevel,
                        state: UIDevice.current.batteryState)
                : nil
            $0 = boundsReducer(state: $0)
        }

    case .proximityStateDidChange:
        return mset(state) {
            $0.proximityMonitor = UIDevice.current.isProximityMonitoringEnabled
                ? .init(isNear: UIDevice.current.proximityState)
                : nil
            $0 = boundsReducer(state: $0)
        }

    case .didChangeBounds, .keyWindowSet, .didRotateDevice:
        return set(state, boundsReducer)
    }

    #elseif os(watchOS)

    switch lifeCycleAction {
    case .boot, .applicationStateDidChange:
        let application = WKExtension.shared()
        let device = WKInterfaceDevice.current()
        return mset(state) {
            $0.application = .some(application)
            $0.applicationState = application.applicationState
            $0.isApplicationRunningInDock = application.isApplicationRunningInDock
            if #available(watchOS 4.2, *) {
                $0.isAutorotated = application.isAutorotated
            }
            $0.isAutorotating = application.isAutorotating
            $0.isFrontmostTimeoutExtended = application.isFrontmostTimeoutExtended
            $0.batteryLevel = device.batteryLevel
            $0.batteryState = device.batteryState
            $0.crownOrientation = device.crownOrientation
            $0.isBatteryMonitoringEnabled = device.isBatteryMonitoringEnabled
            $0.layoutDirection = device.layoutDirection
            $0.localizedModel = device.localizedModel
            $0.model = device.model
            $0.name = device.name
            $0.preferredContentSizeCategory = device.preferredContentSizeCategory
            $0.screenBounds = device.screenBounds
            $0.screenScale = device.screenScale
            $0.systemName = device.systemName
            $0.systemVersion = device.systemVersion
            $0.waterResistanceRating = device.waterResistanceRating
            $0.wristLocation = device.wristLocation
        }
    case .didChangeBatteryLevel:
        let device = WKInterfaceDevice.current()
        return mset(state) {
            $0.batteryLevel = device.batteryLevel
            $0.batteryState = device.batteryState
        }
    }

    #elseif os(tvOS)
    switch lifeCycleAction {
    case let .boot(application, launchOptions):
        return mset(state) {
            $0.application = .some(application)
            $0.launchOptions = launchOptions.map(Transient.some) ?? . none
            $0.device = UIDevice.current.userInterfaceIdiom
            $0 = boundsReducer(state: $0)
        }

    case .applicationStateDidChange:
        return mset(state) {
            $0.applicationState = $0.application.value?.applicationState ?? .background
            $0 = boundsReducer(state: $0)
        }

    case .didChangeBounds, .keyWindowSet:
        return set(state, boundsReducer)
    }

    #elseif os(macOS)
    return state
    #endif
}

#if os(iOS)
private func boundsReducer(state: AppState) -> AppState {
    return mset(state) {
        guard let application = $0.application.value else { return }
        $0.interfaceOrientation = application.statusBarOrientation
        $0.deviceOrientation = UIDevice.current.isGeneratingDeviceOrientationNotifications ? UIDevice.current.orientation : .unknown

        guard let window = application.keyWindow else { return }
        $0.bounds = window.bounds
        $0.sizeClass = .init(horizontal: window.traitCollection.horizontalSizeClass,
                             vertical: window.traitCollection.verticalSizeClass)
        if #available(iOS 11, *) {
            $0.safeAreaInsets = window.safeAreaInsets
        }
    }
}
#endif

#if os(tvOS)
private func boundsReducer(state: AppState) -> AppState {
    return mset(state) {
        guard let application = $0.application.value else { return }
        guard let window = application.keyWindow else { return }
        $0.bounds = window.bounds
        if #available(tvOS 11, *) {
            $0.safeAreaInsets = window.safeAreaInsets
        }
    }
}
#endif
