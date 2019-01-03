import Core
import RxSwift
import SwiftRex
import UIKit

final class CurrentSongViewController: UIViewController {
    @IBOutlet private weak var songLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var albumArtImageView: UIImageView!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var volumeSlider: UISlider!
    @IBOutlet private weak var muteButton: UIButton!
    @IBOutlet private weak var chromecastButton: UIButton!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dislikeButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var websiteButton: UIButton!
    @IBOutlet private weak var lyricsButton: UIButton!
    @IBOutlet private weak var spotifyButton: UIButton!
    @IBOutlet private weak var appleMusicButton: UIButton!
    @IBOutlet private weak var toolbar: UIStackView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        dataBindings()
    }

    private func configureUI() {
        let airplayViewController = AirplayViewController(frame: .init(x: 0, y: 0, width: 24, height: 24))
        addChild(airplayViewController)

        airplayViewController.view.widthAnchor.constraint(equalToConstant: 24)
        airplayViewController.view.heightAnchor.constraint(equalToConstant: 24)
        airplayViewController.view.tintColor = ColorName.bodyBackground.color
        toolbar.insertArrangedSubview(airplayViewController.view, at: 0)

        configureUserInput()
    }

    private func configureUserInput() {
        let dispatch: (EventProtocol) -> Void = { [weak self] in self?.eventHandler.dispatch($0) }

        shareButton.rx.tap
            .map { [weak shareButton] in shareButton }
            .unwrap()
            .map(Either<UIView, CGRect>.left)
            .map(curry(NavigationEvent.requestShareSheet)(self))
            .subscribe(onNext: dispatch)
            .disposed(by: disposeBag)
    }

    private func dataBindings() {
        let songChanges = stateProvider.map(get(\.currentSong)).distinctUntilChanged()
        let cacheChanges = stateProvider.map(get(\.fileCache.value)).distinctUntilChanged(get(\.count))

        Observable.combineLatest(songChanges, cacheChanges)
            .asDriver(onErrorJustReturn: (nil, [:]))
            .drive(onNext: { [weak self] (playlist, cache) in
                guard let playlist = playlist else { return }
                let albumArt = (playlist.song.albumArt?.url.absoluteString)
                    .flatMap { cache[$0]?() }
                    .flatMap(UIImage.init(data:))
                self?.updateUI(playlist, albumArt: albumArt)
            }).disposed(by: disposeBag)

        stateProvider
            .map(get(\.app))
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: AppState())
            .drive(onNext: { app in

            }).disposed(by: disposeBag)
    }

    private func updateUI(_ playlist: Playlist, albumArt: UIImage?) {
        artistLabel.text = playlist.song.artist.artistName
        songLabel.text = playlist.song.songName
        albumArtImageView.image = albumArt
    }
}

extension CurrentSongViewController: HasStateProvider { }
extension CurrentSongViewController: HasEventHandler { }
