import Core
import SwiftRex
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    fileprivate let store = MainStore()
    var window: UIWindow?
}

func inject<T>(_ type: T.Type) -> T {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    if type == MainStateProvider.self {
        return appDelegate.store as! T
    }

    if type == EventHandler.self {
        return appDelegate.store as! T
    }

    fatalError("Oops, dependency not mapped")
}
