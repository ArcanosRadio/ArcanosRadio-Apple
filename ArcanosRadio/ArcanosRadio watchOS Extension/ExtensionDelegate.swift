import Core
import SwiftRex
import SwiftRex_LoggerMiddleware
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    fileprivate let store = MainStore()
    private var radio: RadioPlayer!

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        radio = RadioPlayer()
        if #available(watchOS 5.0, *) {
            radio.activateSession()
            radio.play()
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        backgroundTasks.forEach {
            $0.setTaskCompleted()
        }
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
//        for task in backgroundTasks {
//            // Use a switch statement to check the task type
//            switch task {
//            case let backgroundTask as WKApplicationRefreshBackgroundTask:
//                // Be sure to complete the background task once you’re done.
//                backgroundTask.setTaskCompletedWithSnapshot(false)
//            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
//                // Snapshot tasks have a unique completion call, make sure to set your expiration date
//                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
//            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
//                // Be sure to complete the connectivity task once you’re done.
//                connectivityTask.setTaskCompletedWithSnapshot(false)
//            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
//                // Be sure to complete the URL session task once you’re done.
//                urlSessionTask.setTaskCompletedWithSnapshot(false)
//            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
//                // Be sure to complete the relevant-shortcut task once you're done.
//                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
//            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
//                // Be sure to complete the intent-did-run task once you're done.
//                intentDidRunTask.setTaskCompletedWithSnapshot(false)
//            default:
//                // make sure to complete unhandled task types
//                task.setTaskCompletedWithSnapshot(false)
//            }
//        }
    }
}

func inject<T>(_ type: T.Type) -> T {
    let appDelegate = WKExtension.shared().delegate as! ExtensionDelegate

    if type == MainStateProvider.self {
        return appDelegate.store as! T
    }

    if type == EventHandler.self {
        return appDelegate.store as! T
    }

    fatalError("Oops, dependency not mapped")
}

public let MainMiddleware: () -> ComposedMiddleware<MainState> = {
    return AppLifeCycleMiddleware(trackDeviceOrientation: true, trackBattery: true, trackProximityState: true).lift(\.app)
//        <> RouterMiddleware().lift(\.navigation)
//        <> SongUpdaterMiddleware().lift(\.currentSong)
//        <> ParseMiddleware().lift(\.currentSong)
        <> DirectLineMiddleware()
        <> LoggerMiddleware(eventFilter: { _, _ in true },
                            actionFilter: { _, _ in true },
                            debugOnly: true,
                            stateTransformer: { _ in "" })
        <> CatchErrorMiddleware { errorAction, state in
            print("Error: \(errorAction.error) on \(errorAction.message)")
            return .cauterize
    }
}

public let MainReducer: () -> Reducer<MainState> = {
    return appLifeCycleReducer.lift(\.app)
//        <> apiResponseReducer
//        <> songUpdaterReducer.lift(\.currentSong)
//        <> navigationReducer.lift(\.navigation)
}

extension MainStore {
    public convenience init() {
        self.init(initialState: .init(),
                  reducer: MainReducer(),
                  middleware: MainMiddleware())
    }
}

extension HasStateProvider {
    var stateProvider: MainStateProvider {
        return inject(MainStateProvider.self)
    }
}

extension HasEventHandler {
    var eventHandler: EventHandler {
        return inject(EventHandler.self)
    }
}
