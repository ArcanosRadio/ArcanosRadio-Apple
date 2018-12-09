import AVFoundation
import Foundation
import RxSwift
import SwiftRex
import WatchKit

public class RadioPlayer {
//    private var asset: AVURLAsset?
//    private var streaming: AVPlayerItem?
//    private var player: AVPlayer?
//    private var session: AVAudioSession = AVAudioSession.sharedInstance()
//    private var disposeBag = DisposeBag()

    public init() { }

//    public func configure(url: URL) {
//        disposeBag = DisposeBag()
//
//        asset = .init(url: url)
//        streaming = .init(asset: asset!)
//        player = AVPlayer()
//
//        guard let player = self.player, let streaming = self.streaming else { return }
//
//        Observable<Void>.merge(
//            player.rx.observe(AVPlayer.Status.self, #keyPath(AVPlayer.status)).map { _ in () },
//            player.rx.observe(AVPlayer.TimeControlStatus.self, #keyPath(AVPlayer.timeControlStatus)).map { _ in () },
//            player.rx.observe(AVPlayer.WaitingReason.self, #keyPath(AVPlayer.reasonForWaitingToPlay)).map { _ in () },
//            streaming.rx.observe(AVPlayerItem.Status.self, #keyPath(AVPlayerItem.status)).map { _ in () }
//            ).map { [weak player, weak streaming] _ in
//                guard let player = player, let streaming = streaming else { return nil }
//                switch (player.status, player.timeControlStatus, player.reasonForWaitingToPlay) {
//                case (_, .playing, _): return RadioPlayerEvent.playing
//                case (.failed, _, _): return RadioPlayerEvent.failure(streaming.error ?? player.error)
//                case (.readyToPlay, .paused, _): return RadioPlayerEvent.paused
//                case (_, .waitingToPlayAtSpecifiedRate, .toMinimizeStalls?): return RadioPlayerEvent.notEnoughBuffer
//                case (_, .waitingToPlayAtSpecifiedRate, .evaluatingBufferingRate?): return RadioPlayerEvent.evaluatingBufferingRate
//                case (_, .waitingToPlayAtSpecifiedRate, .noItemToPlay?): return RadioPlayerEvent.noItemToPlay
//                case (.unknown, _, nil): return RadioPlayerEvent.stopped
//                default: fatalError()
//                }
//            }.filter { $0 != nil }.map { $0! }
//            .distinctUntilChanged()
//            .bind(to: pipe)
//            .disposed(by: disposeBag)
//    }
//
    let audioSession = AVAudioSession.sharedInstance()

    @available(watchOS 5.0, *)
    public func play() {
        audioSession.activate(options: []) { active, error in
            if let error = error {
                print(error)
                return
            }

            let url = URL(string: "http://player.liderstreaming.com.br/player/16300/iphone.m3u")!
            //        let asset = WKAudioFileAsset(url: url)
            //        let streaming = WKAudioFilePlayerItem(asset: asset)
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.play()
            } catch {
                print(error)
            }
        }
    }

    @available(watchOS 5.0, *)
    public func activateSession() {
        do {
            try audioSession.setCategory(.playback,
                                         mode: .default,
                                         policy: .longForm,
                                         options: [])
        } catch {
//            pipe.onNext(RadioPlayerEvent.failure(error))
        }
    }

//    public func stop() {
//        player?.pause()
//    }
//
//    public func togglePause() {
//        if isPaused {
//            play()
//        } else {
//            stop()
//        }
//    }
//
//    public var isPlaying: Bool {
//        return player?.timeControlStatus == .playing
//    }
//
//    public var isPaused: Bool {
//        return player?.timeControlStatus == .paused
//    }
//
//    public var isBuffering: Bool {
//        return player?.timeControlStatus == .waitingToPlayAtSpecifiedRate
//    }
}
//
//extension AVPlayer.Status: CustomDebugStringConvertible {
//    public var debugDescription: String {
//        switch self {
//        case .failed: return "failed"
//        case .readyToPlay: return "readyToPlay"
//        case .unknown: return "unknown"
//        }
//    }
//}
//
//extension AVPlayer.TimeControlStatus: CustomDebugStringConvertible {
//    public var debugDescription: String {
//        switch self {
//        case .paused: return "paused"
//        case .playing: return "playing"
//        case .waitingToPlayAtSpecifiedRate: return "waitingToPlayAtSpecifiedRate"
//        }
//    }
//}
//
//extension AVPlayerItem.Status: CustomDebugStringConvertible {
//    public var debugDescription: String {
//        switch self {
//        case .failed: return "failed"
//        case .readyToPlay: return "readyToPlay"
//        case .unknown: return "unknown"
//        }
//    }
//}
//
//extension AVPlayer.WaitingReason: CustomDebugStringConvertible {
//    public var debugDescription: String {
//        switch self {
//        case .toMinimizeStalls: return "toMinimizeStalls"
//        case .evaluatingBufferingRate: return "evaluatingBufferingRate"
//        case .noItemToPlay: return "noItemToPlay"
//        default: return "unknown"
//        }
//    }
//}
