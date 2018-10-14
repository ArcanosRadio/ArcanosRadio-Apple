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

        store[\.app]
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

        store.dispatch(AppLifeCycleEvent.boot(application: UIApplication.shared,
                                              launchOptions: nil))
    }

    private func updateUI(_ playlist: Playlist) {
        artistLabel.text = playlist.song.artist.artistName
        songLabel.text = playlist.song.songName
        lyricsLabel.text = playlist.song.lyrics?.name
    }
}

extension UIInterfaceOrientation: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        case .unknown: return "unknown"
        }
    }
}

extension UIUserInterfaceSizeClass: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .compact: return "compact"
        case .regular: return "regular"
        case .unspecified: return "unspecified"
        }
    }
}

extension UIApplication.State: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .active: return "active"
        case .background: return "background"
        case .inactive: return "inactive"
        }
    }
}

extension UIDeviceOrientation: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .faceDown: return "faceDown"
        case .faceUp: return "faceUp"
        case .landscapeLeft: return "landscapeLeft"
        case .landscapeRight: return "landscapeRight"
        case .portrait: return "portrait"
        case .portraitUpsideDown: return "portraitUpsideDown"
        case .unknown: return "unknown"
        }
    }
}

extension UIDevice.BatteryState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .charging: return "charging"
        case .full: return "full"
        case .unknown: return "unknown"
        case .unplugged: return "unplugged"
        }
    }
}

extension UIUserInterfaceIdiom: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .carPlay: return "carPlay"
        case .pad: return "iPad"
        case .phone: return "iPhone"
        case .tv: return "Apple TV"
        case .unspecified: return "Unspecified"
        }
    }
}
