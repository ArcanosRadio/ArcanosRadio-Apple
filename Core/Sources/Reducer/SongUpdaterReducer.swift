import Foundation
import SwiftRex

public let songUpdaterReducer = Reducer<MainState> { state, action in
    switch action {
    case SongUpdaterAction.songHasChanged(let newSong):
        var stateCopy = state
        stateCopy.currentSong = newSong
        return stateCopy
    default:
        break
    }

    return state
}
