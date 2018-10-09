import RxSwift
import SwiftRex

final class ParseService: SideEffectProducer {
//    var event: RepositorySearchEvent

//    init(event: RepositorySearchEvent) {
//        self.event = event
//    }

    func execute(getState: @escaping () -> MainState) -> Observable<ActionProtocol> {
        let state = getState()

        return requestStreamingServer().map { $0 as ActionProtocol }
    }
}

func requestStreamingServer() -> Observable<StreamingServerResponse> {
    return .empty()
}

enum ParseEndpoint {
    case config
    case lastSong
    case resource(ParseResource)
}

extension ParseEndpoint {
    func buildRequest() -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = requestHeaders
        urlRequest.httpMethod = method
        urlRequest.httpBody = body

        return urlRequest
    }

    private var url: URL {
        switch self {
        case .config:
            return URL(string: "https://api.arcanosmc.com.br/parse/config")!
        case .lastSong:
            return URL(string: "https://api.arcanosmc.com.br/parse/classes/Playlist")!
        case let .resource(resource):
            return resource.url
        }
    }

    private var requestHeaders: [String: String] {
        return [
            "X-Parse-Application-Id": "",
            "X-Parse-Client-Key": "",
            "X-Parse-Installation-Id": "",
            "X-Parse-OS-Version": "",
            "X-Parse-Client-Version": "",
            "X-Parse-App-Build-Version": "",
            "X-Parse-App-Display-Version": ""
        ]
    }

    private var method: String {
        switch self {
        case .config, .resource: return "GET"
        case .lastSong: return "POST"
        }
    }

    private var body: Data? {
        switch self {
        case .config, .resource: return nil
        case .lastSong: return try? JSONEncoder().encode(ParseRequestBody.lastSong)
        }
    }
}

struct ParseRequestBody: Codable, Equatable {
    let include: String?
    let order: String?
    let method: String?
    let limit: String?

    enum CodingKeys: String, CodingKey {
        case include, order, limit
        case method = "_method"
    }
}

extension ParseRequestBody {
    static let lastSong = ParseRequestBody(
        include: "song.artist",
        order: "-createdAt",
        method: "GET",
        limit: "1")
}
