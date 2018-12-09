import Foundation
import SwiftRex

public enum RequestProgress<T: Codable & Equatable>: ActionProtocol, Equatable {
    case started
    case success(T)
    case failure(Error)
}

extension RequestProgress {
    public var value: T? { if case let .success(value) = self { return value } else { return nil } }
    public var error: Error? { if case let .failure(error) = self { return error } else { return nil } }

    @discardableResult
    public func analysis(onSuccess: (T) -> Void = { _ in },
                         onFailure: (Error) -> Void = { _ in },
                         onStarted: () -> Void = { }) -> RequestProgress {
        switch self {
        case .started: onStarted()
        case let .success(value): onSuccess(value)
        case let .failure(error): onFailure(error)
        }
        return self
    }
}

public func == <T>(lhs: RequestProgress<T>, rhs: RequestProgress<T>) -> Bool {
    switch (lhs, rhs) {
    case (.started, .started):
        return true
    case let (.success(lhs), .success(rhs)):
        return lhs == rhs
    case let (.failure(lhs), .failure(rhs)):
        return lhs.localizedDescription == rhs.localizedDescription
    default: return false
    }
}

extension RequestProgress: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let _ = try container.decodeIfPresent(Bool.self, forKey: .started) {
            self = .started
        } else if let error = try container.decodeIfPresent(String.self, forKey: .failure) {
            self = .failure(NSError(domain: error, code: 0, userInfo: nil))
        } else if let value = try container.decodeIfPresent(T.self, forKey: .success) {
            self = .success(value)
        }
        throw DecodingError.keyNotFound(CodingKeys.started,
                                        DecodingError.Context(codingPath: decoder.codingPath,
                                                              debugDescription: "Expected one of the following keys: started, failure, success"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .started:
            try container.encode(true, forKey: .started)
        case let .failure(error):
            try container.encode(error.localizedDescription, forKey: .failure)
        case let .success(value):
            try container.encode(value, forKey: .success)
        }
    }

    enum CodingKeys: String, CodingKey {
        case started
        case success
        case failure
    }
}
