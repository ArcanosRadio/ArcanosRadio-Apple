import AVFoundation
import Foundation

public class RadioPlayer {
    private var streaming: AVPlayerItem?
    private var player: AVPlayer?
    private var session: AVAudioSession?

    public init() { }

    public func configure(url: URL) {
        streaming = .init(url: url)
        player = AVPlayer(playerItem: streaming)
        session = AVAudioSession.sharedInstance()

        do {
            try session!.setCategory(.playback,
                                     mode: .default,
                                     options: [.mixWithOthers])
            try session!.setActive(true, options: [])
        } catch {
            print(error)
            // dispatch error
        }
    }

    public func play() {
        guard let player = player, let streaming = streaming else { return }

        player.allowsExternalPlayback = true
        player.replaceCurrentItem(with: nil)
        player.replaceCurrentItem(with: streaming)
        player.play()
        // dispatch event
    }

    public func stop() {
        player?.pause()
        // dispatch event
    }

    public func togglePause() {
        if player?.timeControlStatus == .playing {
            stop()
        } else {
            play()
        }
    }
}
