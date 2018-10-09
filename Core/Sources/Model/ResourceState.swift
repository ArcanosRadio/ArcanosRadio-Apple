import Foundation

public enum ResourceState: Int, Codable, Equatable {
    case pending = 0
    case error = 1
    case notAvailable = 2
    case downloaded = 3
}
