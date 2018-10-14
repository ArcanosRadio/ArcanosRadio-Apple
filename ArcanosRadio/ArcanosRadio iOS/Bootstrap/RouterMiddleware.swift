import Core
import SwiftRex

public final class RouterMiddleware: Middleware {
    public var actionHandler: ActionHandler?

    public func handle(event: EventProtocol, getState: @escaping () -> Sitemap, next: @escaping (EventProtocol, @escaping () -> Sitemap) -> Void) {
        defer {
            next(event, getState)
        }

        switch event {
        case let AppLifeCycleEvent.boot(application, _):
            next(NavigationEvent.requestNavigation(.currentSong), getState)
            let appDelegate = (application.delegate as! AppDelegate)
            let window = UIWindow()
            appDelegate.window = window

            let vc = CurrentSongViewController(nibName: nil, bundle: nil)
            window.rootViewController = vc
            window.makeKeyAndVisible()
            actionHandler?.trigger(NavigationAction.navigationDidEnd(.currentSong))
        default:
            break
        }
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> Sitemap, next: @escaping (ActionProtocol, @escaping () -> Sitemap) -> Void) {
        defer {
            next(action, getState)
        }
    }

    public init() { }
}
