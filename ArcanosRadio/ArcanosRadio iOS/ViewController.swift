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
                print("************************************")
                dump(app)
//                print("State: \(app.applicationState), active: \(app.active), foreground: \(app.foreground)")
//                print("Bounds: \(app.bounds)")
//                print("KB: \(app.keyboardHeight)")
//                print("SA: \(app.safeAreaInsets)")
//                print("HSC: \(app.horizontalSizeClass) x VSC: \(app.verticalSizeClass)")
//                print("Interface Orientation: \(app.interfaceOrientation)")
//                print("Device Orientation: \(app.deviceOrientation)")
//                print("Proximity: \(app.proximityState)")
//                print("Device: \(app.device)")
//                print("Battery: \(app.batteryLevel) (\(app.batteryState))")
                print("************************************")
            }).disposed(by: disposeBag)

        eventHandler.dispatch(AppLifeCycleEvent.boot(application: UIApplication.shared,
                                                     launchOptions: nil))
    }

    private func updateUI(_ playlist: Playlist) {
        artistLabel.text = playlist.song.artist.artistName
        songLabel.text = playlist.song.songName
        lyricsLabel.text = playlist.song.lyrics?.name
    }
}

extension ViewController: HasStateProvider { }
extension ViewController: HasEventHandler { }
