import SwiftRex

public final class RouterMiddleware: Middleware {
    public var actionHandler: ActionHandler?

    public func handle(event: EventProtocol, getState: @escaping () -> MainState, next: @escaping (EventProtocol, @escaping () -> MainState) -> Void) {
        defer {
            next(event, getState)
        }

//        if .boot(_, _)? = event as? AppLifeCycleEvent {
//            actionHandler?.trigger(NavigationAction.navigationStarted(.playMode))
//            RigListWireframe.start(window)
//            window.makeKeyAndVisible()
//            actionHandler?.trigger(NavigationAction.navigationCompleted(.playMode))
//        }
    }

    public func handle(action: ActionProtocol, getState: @escaping () -> MainState, next: @escaping (ActionProtocol, @escaping () -> MainState) -> Void) {
        defer {
            next(action, getState)
        }
    }

    public init() { }
}

//public class NavigationMiddleware: Middleware {
//    //    public typealias StateType = <#type#>
//
//    func execute(getState: @escaping () -> AppState,
//                 dispatch: @escaping DispatchFunction,
//                 dispatchAsync: @escaping (AnyActionAsync<AppState>) -> ()) {
//        let currentState = getState()
//        guard let navigationController = currentState.osState.navigationController else { return }
//
//        switch self {
//        case .navigate(let journey):
//            dispatch(RouterAction.willNavigate(journey.route))
//            journey.navigate(navigationController) {
//                dispatch(RouterAction.didNavigate(journey.route.destination))
//            }
//        }
//    }
//}
