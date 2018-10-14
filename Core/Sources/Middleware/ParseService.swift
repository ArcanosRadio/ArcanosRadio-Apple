import RxCocoa
import RxSwift
import SwiftRex

final class ParseService: SideEffectProducer {
    var request: () -> Observable<ActionProtocol>

    init?(event: EventProtocol) {
        switch event {
        case AppLifeCycleEvent.boot:
            request = { requestStreamingServer().map { $0 as ActionProtocol } }
        case RefreshTimerEvent.tick:
            request = { requestCurrentSong().map { $0 as ActionProtocol } }
        default:
            return nil
        }
    }

    func execute(getState: @escaping () -> Playlist?) -> Observable<ActionProtocol> {
        return request()
    }
}

func requestStreamingServer() -> Observable<RequestProgress<StreamingServer>> {
    return Observable.concat(
        .just(RequestProgress<StreamingServer>.started),
        execute(type: ParseConfigResponse<StreamingServer>.self,
                request: ParseEndpoint.config.buildRequest())
            .map { .success($0.params) }
            .catchError { .just(.failure($0)) }
    )
}

func requestCurrentSong() -> Observable<RequestProgress<Playlist>> {
    return Observable.concat(
        .just(RequestProgress<Playlist>.started),
        execute(type: ParseQueryResponse<Playlist>.self,
                request: ParseEndpoint.lastSong.buildRequest())
            .map { $0.results.first.map(RequestProgress<Playlist>.success) ?? .started }
            .catchError { .just(.failure($0)) }
    )
}

func execute<T: Decodable>(type: T.Type, request: URLRequest) -> Observable<T> {
    Logging.URLRequests = { _ in false }
    return URLSession.shared
        .rx.response(request: request)
        .map { (response, data) in
            guard 200...299 ~= response.statusCode else {
                throw NSError(domain: "Invalid status code: \(response.statusCode)", code: 0, userInfo: nil)
            }

            return try decoder().decode(T.self, from: data)
        }
        .retry(3)
}

func decoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected date string to be POSIX")
    })

    return decoder
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
            "X-Parse-Application-Id":       "arcanosRadio",
            "Content-Type":                 "application/json"
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
