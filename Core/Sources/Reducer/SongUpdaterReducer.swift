import Foundation
import SwiftRex

extension Reducer where StateType == Playlist? {
    public static let songUpdater = Reducer { state, action in
        switch action {
        case SongUpdaterAction.songHasChanged(let newSong):
            return newSong
        default:
            break
        }

        return state
    }
}
