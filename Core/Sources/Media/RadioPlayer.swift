import AVFoundation
import Foundation

public class RadioPlayer {
    private var streaming: AVPlayerItem?
    private var player: AVPlayer?
    private var volume: Float = 0.0
    private var session: AVAudioSession?

    public init() { }

    public func configure(url: URL) {
        streaming = .init(url: url)
        player = AVPlayer(playerItem: streaming)
        session = AVAudioSession.sharedInstance()
    }

    public func play() {
        guard let player = player, let session = session, let streaming = streaming else { return }

        do {
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: .default,
                                    options: [.mixWithOthers])
        } catch {
            print(error)
            // dispatch error
        }

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
