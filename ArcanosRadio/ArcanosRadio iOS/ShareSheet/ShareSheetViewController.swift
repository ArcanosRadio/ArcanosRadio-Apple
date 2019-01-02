import Core
import UIKit
import RxSwift
import SwiftRex

fileprivate final class ShareTextViewController: UIActivityViewController {
    init(playlist: Playlist, shareUrl: String, sourceView: UIView?, sourceRect: CGRect) {

        let songName = playlist.song.songName
        let artistName = playlist.song.artist.artistName
        let text = L10n.shareText(songName, artistName, shareUrl)

        super.init(activityItems: [text], applicationActivities: nil)

        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.sourceRect = sourceRect
    }
}

final class ShareSheetViewController {
    let disposeBag = DisposeBag()
    let done: () -> Void

    init(done: @escaping () -> Void) {
        self.done = done
    }

    func present(from vc: UIViewController, sourceView: UIView, onPresented: @escaping () -> Void) {
        present(from: vc, sourceView: sourceView, sourceRect: sourceView.bounds, onPresented: onPresented)
    }

    func present(from vc: UIViewController, sourceRect: CGRect, onPresented: @escaping () -> Void) {
        present(from: vc, sourceView: nil, sourceRect: sourceRect, onPresented: onPresented)
    }

    private func present(from vc: UIViewController, sourceView: UIView?, sourceRect: CGRect, onPresented: @escaping () -> Void) {
        weak var weakSelf = self
        stateProvider
            .map { zip($0.currentSong, $0.streamingServer?.value?.shareUrl) }
            .unwrap()
            .take(1)
            .subscribe(onNext: { currentSong, shareUrl in
                let shareTextViewController = ShareTextViewController(playlist: currentSong,
                                                                      shareUrl: shareUrl,
                                                                      sourceView: sourceView,
                                                                      sourceRect: sourceRect)

                shareTextViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                    weakSelf?.done()
                }

                vc.present(shareTextViewController, animated: true) {
                    onPresented()
                }
            }).disposed(by: disposeBag)
    }
}

extension ShareSheetViewController: HasEventHandler { }
extension ShareSheetViewController: HasStateProvider { }
