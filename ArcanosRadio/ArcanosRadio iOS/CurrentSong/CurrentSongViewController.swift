import Core
import RxSwift
import SwiftRex
import UIKit

final class CurrentSongViewController: UIViewController {
    @IBOutlet private weak var songLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var lyricsLabel: UILabel!
    @IBOutlet private weak var albumArtImageView: UIImageView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let songChanges = stateProvider.map(get(\.currentSong)).distinctUntilChanged()
        let cacheChanges = stateProvider.map(get(\.fileCache.value)).distinctUntilChanged(get(\.count))

        Observable.combineLatest(songChanges, cacheChanges)
            .asDriver(onErrorJustReturn: (nil, [:]))
            .drive(onNext: { [weak self] (playlist, cache) in
                guard let playlist = playlist else { return }
                let lyrics = (playlist.song.lyrics?.url.absoluteString)
                    .flatMap { cache[$0]?() }
                    .flatMap { String(data: $0, encoding: .utf8) }
                let albumArt = (playlist.song.albumArt?.url.absoluteString)
                    .flatMap { cache[$0]?() }
                    .flatMap(UIImage.init(data:))
                self?.updateUI(playlist, lyrics: lyrics, albumArt: albumArt)
            }).disposed(by: disposeBag)

        stateProvider
            .map(get(\.app))
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: AppState())
            .drive(onNext: { app in

            }).disposed(by: disposeBag)
    }

    private func updateUI(_ playlist: Playlist, lyrics: String?, albumArt: UIImage?) {
        artistLabel.text = playlist.song.artist.artistName
        songLabel.text = playlist.song.songName
        lyricsLabel.text = lyrics
        albumArtImageView.image = albumArt
    }
}

extension CurrentSongViewController: HasStateProvider { }
extension CurrentSongViewController: HasEventHandler { }
