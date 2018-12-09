import AVFoundation
import Foundation
import RxSwift
import SwiftRex

public class RadioPlayer: ObservableType {
    public typealias E = RadioPlayerEvent
    private let pipe = BehaviorSubject<RadioPlayerEvent>(value: .stopped)

    public func subscribe<O>(_ observer: O) -> Disposable where O: ObserverType, O.E == RadioPlayerEvent {
        return pipe.subscribe(observer)
    }

    private var asset: AVAsset?
    private var streaming: AVPlayerItem?
    private var player: AVPlayer?
    private var session: AVAudioSession = AVAudioSession.sharedInstance()
    private var disposeBag = DisposeBag()

    public init() { }

    public func configure(url: URL) {
        disposeBag = DisposeBag()

        asset = .init(url: url)
        streaming = .init(asset: asset!)
        player = AVPlayer()

        guard let player = self.player, let streaming = self.streaming else { return }

        Observable<Void>.merge(
            player.rx.observe(AVPlayer.Status.self, #keyPath(AVPlayer.status)).map { _ in () },
            player.rx.observe(AVPlayer.TimeControlStatus.self, #keyPath(AVPlayer.timeControlStatus)).map { _ in () },
            player.rx.observe(AVPlayer.WaitingReason.self, #keyPath(AVPlayer.reasonForWaitingToPlay)).map { _ in () },
            streaming.rx.observe(AVPlayerItem.Status.self, #keyPath(AVPlayerItem.status)).map { _ in () }
        ).map { [weak player, weak streaming] _ in
            guard let player = player, let streaming = streaming else { return nil }
            switch (player.status, player.timeControlStatus, player.reasonForWaitingToPlay) {
            case (_, .playing, _): return RadioPlayerEvent.playing
            case (.failed, _, _): return RadioPlayerEvent.failure(streaming.error ?? player.error)
            case (.readyToPlay, .paused, _): return RadioPlayerEvent.paused
            case (_, .waitingToPlayAtSpecifiedRate, .toMinimizeStalls?): return RadioPlayerEvent.notEnoughBuffer
            case (_, .waitingToPlayAtSpecifiedRate, .evaluatingBufferingRate?): return RadioPlayerEvent.evaluatingBufferingRate
            case (_, .waitingToPlayAtSpecifiedRate, .noItemToPlay?): return RadioPlayerEvent.noItemToPlay
            case (.unknown, _, nil): return RadioPlayerEvent.stopped
            default: fatalError()
            }
        }.filter { $0 != nil }.map { $0! }
        .distinctUntilChanged()
        .bind(to: pipe)
        .disposed(by: disposeBag)
    }

    public func play() {
        guard let player = player, let streaming = streaming else { return }
        guard player.rate != 1.0 else { return }

        player.allowsExternalPlayback = true
        player.replaceCurrentItem(with: nil)
        player.play()
        player.replaceCurrentItem(with: streaming)

        activateSession()
    }

    public func activateSession() {
        do {
            if #available(iOS 11.0, tvOS 11.0, *) {
                try session.setCategory(.playback,
                                        mode: .default,
                                        policy: .longForm,
                                        options: [])
            } else {
                try session.setCategory(.playback,
                                        mode: .default,
                                        options: [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP])
            }
            try session.setActive(true, options: [])
        } catch {
            pipe.onNext(RadioPlayerEvent.failure(error))
        }
    }

    public func stop() {
        player?.pause()
    }

    public func togglePause() {
        if isPaused {
            play()
        } else {
            stop()
        }
    }

    public var isPlaying: Bool {
        return player?.timeControlStatus == .playing
    }

    public var isPaused: Bool {
        return player?.timeControlStatus == .paused
    }

    public var isBuffering: Bool {
        return player?.timeControlStatus == .waitingToPlayAtSpecifiedRate
    }
}

extension AVPlayer.Status: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .failed: return "failed"
        case .readyToPlay: return "readyToPlay"
        case .unknown: return "unknown"
        }
    }
}

extension AVPlayer.TimeControlStatus: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .paused: return "paused"
        case .playing: return "playing"
        case .waitingToPlayAtSpecifiedRate: return "waitingToPlayAtSpecifiedRate"
        }
    }
}

extension AVPlayerItem.Status: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .failed: return "failed"
        case .readyToPlay: return "readyToPlay"
        case .unknown: return "unknown"
        }
    }
}

extension AVPlayer.WaitingReason: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .toMinimizeStalls: return "toMinimizeStalls"
        case .evaluatingBufferingRate: return "evaluatingBufferingRate"
        case .noItemToPlay: return "noItemToPlay"
        default: return "unknown"
        }
    }
}
