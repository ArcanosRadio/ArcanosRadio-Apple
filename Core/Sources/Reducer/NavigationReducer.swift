import Foundation
import SwiftRex

extension Reducer where StateType == Sitemap {
    public static let navigation = Reducer { state, action in
        switch action {
        case let NavigationAction.navigationDidEnd(sitemap):
            return sitemap
        default:
            break
        }

        return state
    }
}
