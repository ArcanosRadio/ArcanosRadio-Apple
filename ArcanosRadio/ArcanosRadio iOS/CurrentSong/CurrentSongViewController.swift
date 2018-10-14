import Core
import RxSwift
import SwiftRex
import UIKit

class CurrentSongViewController: UIViewController {
    @IBOutlet private weak var songLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var lyricsLabel: UILabel!
    @IBOutlet private weak var albumArtImageView: UIImageView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        stateProvider[\.currentSong]
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] playlist in
                guard let playlist = playlist else { return }
                self?.updateUI(playlist)
            }).disposed(by: disposeBag)

        stateProvider[\.app]
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: AppState())
            .drive(onNext: { app in

            }).disposed(by: disposeBag)
    }

    private func updateUI(_ playlist: Playlist) {
        artistLabel.text = playlist.song.artist.artistName
        songLabel.text = playlist.song.songName
        lyricsLabel.text = playlist.song.lyrics?.name
    }
}

extension CurrentSongViewController: HasStateProvider { }
extension CurrentSongViewController: HasEventHandler { }
