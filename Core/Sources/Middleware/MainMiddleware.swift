import Foundation
import SwiftRex

public let MainMiddleware: () -> ComposedMiddleware<MainState> = {
    return LifeCycleMiddleware()
        <> RouterMiddleware()
}
