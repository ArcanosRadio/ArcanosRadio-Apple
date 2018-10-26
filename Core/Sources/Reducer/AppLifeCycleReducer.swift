import Foundation
import SwiftRex

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
    return state
    #elseif os(tvOS)
    return state
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

#elseif os(watchOS)
private func boundsReducer(state: AppState) -> AppState { return state }

#elseif os(tvOS)
private func boundsReducer(state: AppState) -> AppState { return state }

#elseif os(macOS)
private func boundsReducer(state: AppState) -> AppState { return state }
#endif
