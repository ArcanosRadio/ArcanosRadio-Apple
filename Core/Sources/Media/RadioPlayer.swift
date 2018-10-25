import AVFoundation
import Foundation

public class RadioPlayer {
    private var streaming: AVPlayerItem?
    private var player: AVPlayer?
    private var volume: Float = 0.0

    public init() { }

    public func configure(url: URL) {
        streaming = .init(url: url)
        player = AVPlayer.init(playerItem: streaming)
        volume = 0.0
    }

    public func play() {
        guard let player = player, let streaming = streaming else { return }
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
