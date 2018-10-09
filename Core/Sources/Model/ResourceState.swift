import Foundation

public enum ResourceState: Int, Equatable, Codable {
    case pending = 0
    case error = 1
    case notAvailable = 2
    case downloaded = 3
}
