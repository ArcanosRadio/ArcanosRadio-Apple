import AVKit
import Core
import MediaPlayer
import RxSwift
import SwiftRex
import UIKit

enum AirplayPickerEvent {
    case presented
    case done
}

class AirplayViewController: UIViewController {
    private let frame: CGRect

    init(frame: CGRect) {
        self.frame = frame
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        if #available(iOS 11.0, *) {
            let routePickerView = AVRoutePickerView(frame: frame)
            routePickerView.delegate = self
            view = routePickerView
        } else {
            let volumeView = MPVolumeView(frame: frame)
            volumeView.showsRouteButton = true
            volumeView.showsVolumeSlider = false
            view = volumeView
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 11.0, *)
extension AirplayViewController: AVRoutePickerViewDelegate {
    public func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        eventHandler.dispatch(NavigationEvent.requestNavigation(.airplayPicker))
    }

    public func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        eventHandler.dispatch(NavigationEvent.requestNavigation(.currentSong))
    }
}

extension AirplayViewController: HasEventHandler { }
