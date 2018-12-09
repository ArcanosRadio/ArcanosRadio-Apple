import Core
import SwiftRex

public final class RouterMiddleware: Middleware {
    public var actionHandler: ActionHandler?

    public func handle(event: EventProtocol, getState: @escaping () -> Sitemap, next: @escaping (EventProtocol, @escaping () -> Sitemap) -> Void) {
        defer {
            next(event, getState)
        }
        let source = getState()

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
        case let NavigationEvent.requestNavigation(destination):
            switch (source, destination) {
            case (.airplayPicker, _),
                 (_, .airplayPicker):
                actionHandler?.trigger(NavigationAction.navigationDidEnd(destination))
            default:
                break
            }
        case let NavigationEvent.requestShareSheet(viewController, position):
            let shareSheet = ShareSheetViewController { [weak self] in
                next(NavigationEvent.requestNavigation(source), getState)
                self?.actionHandler?.trigger(NavigationAction.navigationDidEnd(source))
            }
            switch position {
            case let .left(view):
                shareSheet.present(from: viewController, sourceView: view) { [weak self] in
                    self?.actionHandler?.trigger(NavigationAction.navigationDidEnd(.shareCurrentSong))
                }
            case let .right(rect):
                shareSheet.present(from: viewController, sourceRect: rect) { [weak self] in
                    self?.actionHandler?.trigger(NavigationAction.navigationDidEnd(.shareCurrentSong))
                }
            }
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
