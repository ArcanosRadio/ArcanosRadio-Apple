import Foundation
import SwiftRex

public enum SongUpdaterAction: ActionProtocol {
    case songHasChanged(Playlist)
}
