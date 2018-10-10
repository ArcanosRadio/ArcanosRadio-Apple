import Core
import RxSwift
import SwiftRex
import UIKit

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    var store = MainStore(
        initialState: .init(),
        reducer: MainReducer(),
        middleware: MainMiddleware())

    override func viewDidLoad() {
        super.viewDidLoad()

        store
            .map(\.currentSong)
            .scan((Playlist?.none, Playlist?.none)) { previous, newValue in
                return (previous.1, newValue)
            }.filter(!=)
            .map { $0.1 }
            .subscribe(onNext: {
                print("Song: \($0?.title ?? "none")")
            }).disposed(by: disposeBag)

        store.dispatch(AppLifeCycleEvent.boot(application: UIApplication.shared,
                                              launchOptions: nil))
    }
}
