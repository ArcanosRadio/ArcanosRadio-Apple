import Foundation
import SwiftRex

public let songUpdaterReducer = Reducer<Playlist?> { state, action in
    switch action {
    case SongUpdaterAction.songHasChanged(let newSong):
        return newSong
    default:
        break
    }

    return state
}
