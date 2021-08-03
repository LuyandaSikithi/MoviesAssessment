import Foundation

// MARK: - All Movies
typealias Response = MovieResponse

struct GetAllMoviesRequest: Request {
   
    var method: HTTPMethod { .GET }
    var path: String { Constants.http.pathMovies }
    var contentType: String { Constants.http.contentTypeJson }
    var additionalHeaders: [String : String] { [:] }
    var body: Data? { nil }
    var parameters: [String:String]? { nil}
    
    func handle(response: Data) throws -> Response {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Response.self, from: response)
    }
}

// MARK: - Movie Search Request

struct GetMovieSearchRequest: Request {
    private let searchedItem: String

    init(_ item: String) { searchedItem = item }
    
    var method: HTTPMethod { .GET }
    var path: String { "\(Constants.http.searchPath)\(searchedItem)".removingPercentEncoding ?? "" }
    var contentType: String { Constants.http.contentTypeJson }
    var additionalHeaders: [String : String] { [:] }
    var body: Data? { nil }
    
    func handle(response: Data) throws -> MovieResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MovieResponse.self, from: response)
    }
}
