import Core
import RxSwift
import SwiftRex
import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var songLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var lyricsLabel: UILabel!
    @IBOutlet private weak var albumArtImageView: UIImageView!
    private let disposeBag = DisposeBag()

    private var store = MainStore(
        initialState: .init(),
        reducer: MainReducer(),
        middleware: MainMiddleware())

    override func viewDidLoad() {
        super.viewDidLoad()

        store[\.currentSong]
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] playlist in
                guard let playlist = playlist else { return }
                self?.updateUI(playlist)
            }).disposed(by: disposeBag)

        store.dispatch(AppLifeCycleEvent.boot(application: UIApplication.shared,
                                              launchOptions: nil))
    }

    private func updateUI(_ playlist: Playlist) {
        artistLabel.text = playlist.song.artist.artistName
        songLabel.text = playlist.song.songName
        lyricsLabel.text = playlist.song.lyrics?.name
    }
}
