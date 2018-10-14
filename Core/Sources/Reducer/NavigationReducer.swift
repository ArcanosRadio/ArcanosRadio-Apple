import Foundation
import SwiftRex

public let navigationReducer = Reducer<Sitemap> { state, action in
    switch action {
    case let NavigationAction.navigationDidEnd(sitemap):
        return sitemap
    default:
        break
    }

    return state
}
