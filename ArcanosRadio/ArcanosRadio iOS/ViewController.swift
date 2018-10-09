import Core
import RxSwift
import SwiftRex
import UIKit

class ViewController: UIViewController {
    var store = MainStore(
        initialState: .init(),
        reducer: MainReducer(),
        middleware: MainMiddleware())

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
