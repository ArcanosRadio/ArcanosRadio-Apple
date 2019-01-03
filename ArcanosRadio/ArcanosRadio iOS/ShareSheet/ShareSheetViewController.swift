import Core
import RxSwift
import SwiftRex
import UIKit

fileprivate final class ShareSongViewController: UIActivityViewController {
    init(playlist: Playlist, shareUrl: String, sourceView: UIView?, sourceRect: CGRect) {

        let songName = playlist.song.songName
        let artistName = playlist.song.artist.artistName
        let text = L10n.shareText(songName, artistName, shareUrl)

        super.init(activityItems: [text], applicationActivities: nil)

        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.sourceRect = sourceRect
    }
}

enum ShareSongEvent {
    case presented
    case done(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?)
}

struct ShareSongController {
    init() { }

    func present(from vc: UIViewController, position: Either<UIView, CGRect>) -> Observable<ShareSongEvent> {
        return stateProvider
            .map { zip($0.currentSong, $0.streamingServer?.value?.shareUrl) }
            .unwrap()
            .take(1)
            .flatMap { (currentSong: Playlist, shareUrl: String) -> Observable<ShareSongEvent> in
                Observable.create { observer in
                    var sourceView: UIView? = nil
                    let sourceRect: CGRect

                    switch position {
                    case let .left(v):
                        sourceRect = v.bounds
                        sourceView = v
                    case let .right(r):
                        sourceRect = r
                    }

                    let shareTextViewController = ShareSongViewController(playlist: currentSong,
                                                                          shareUrl: shareUrl,
                                                                          sourceView: sourceView,
                                                                          sourceRect: sourceRect)

                    shareTextViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                        observer.on(.next(.done(activityType: activityType,
                                                completed: completed,
                                                returnedItems: returnedItems,
                                                activityError: activityError)))
                        observer.on(.completed)
                    }

                    vc.present(shareTextViewController, animated: true) {
                        observer.on(.next(.presented))
                    }

                    return Disposables.create {
                        shareTextViewController.dismiss(animated: false, completion: nil)
                    }
                }
            }
    }
}

extension ShareSongController: HasEventHandler { }
extension ShareSongController: HasStateProvider { }
