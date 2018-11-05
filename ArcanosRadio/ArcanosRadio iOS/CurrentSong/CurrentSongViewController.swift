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
    private let radioPlayer = RadioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        stateProvider[\.streamingServer]
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] server in
                if case let .success(streamingServer)? = server {
                    self?.radioPlayer.configure(url: streamingServer.streamingUrl)
                    self?.radioPlayer.play()
                } else {
                    self?.radioPlayer.stop()
                }
            }).disposed(by: disposeBag)

        let songChanges = stateProvider[\.currentSong].distinctUntilChanged()
        let cacheChanges = stateProvider[\.fileCache.value].distinctUntilChanged { $0.count }

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

        stateProvider[\.app]
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
