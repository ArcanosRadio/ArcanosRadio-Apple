import Foundation
import SwiftRex

public let appLifeCycleReducer = Reducer<AppState> { state, action in
    guard let lifeCycleAction = action as? AppLifeCycleEvent else { return state }

    var stateCopy = state

    #if os(iOS)
    switch lifeCycleAction {
    case let .boot(application, launchOptions):
        stateCopy.application = .some(application)
        stateCopy.launchOptions = launchOptions.map(Transient.some) ?? . none
        stateCopy.device = UIDevice.current.userInterfaceIdiom
    case .applicationStateDidChange:
        stateCopy.applicationState = stateCopy.application.value?.applicationState ?? .background
    case let .keyboardToggle(height):
        stateCopy.keyboardHeight = height
    case .didChangeBatteryLevel:
        stateCopy.batteryMonitor = UIDevice.current.isBatteryMonitoringEnabled
            ? .init(level: UIDevice.current.batteryLevel,
                    state: UIDevice.current.batteryState)
            : nil
    case .proximityStateDidChange:
        stateCopy.proximityMonitor = UIDevice.current.isProximityMonitoringEnabled
            ? .init(isNear: UIDevice.current.proximityState)
            : nil
    case .didChangeBounds, .keyWindowSet, .didRotateDevice:
        break
    }
    #elseif os(watchOS)
    #elseif os(tvOS)
    #elseif os(macOS)
    #endif

    return boundsReducer(state: stateCopy)
}

#if os(iOS)
private func boundsReducer(state: AppState) -> AppState {
    var stateCopy = state

    guard let application = state.application.value else { return stateCopy }
    stateCopy.interfaceOrientation = application.statusBarOrientation
    stateCopy.deviceOrientation = UIDevice.current.isGeneratingDeviceOrientationNotifications ? UIDevice.current.orientation : .unknown

    guard let window = application.keyWindow else { return stateCopy }
    stateCopy.bounds = window.bounds
    stateCopy.sizeClass = .init(horizontal: window.traitCollection.horizontalSizeClass,
                                vertical: window.traitCollection.verticalSizeClass)
    if #available(iOS 11, *) {
        stateCopy.safeAreaInsets = window.safeAreaInsets
    }

    return stateCopy
}

#elseif os(watchOS)
private func boundsReducer(state: AppState) -> AppState { return state }

#elseif os(tvOS)
private func boundsReducer(state: AppState) -> AppState { return state }

#elseif os(macOS)
private func boundsReducer(state: AppState) -> AppState { return state }
#endif
