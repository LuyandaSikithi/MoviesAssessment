import Foundation

enum APIError: Error {
    case requestFailed(Int)
    case noMoviesFound
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestFailed(_):
            return  Constants.failedRequest
        case .noMoviesFound:
            return Constants.noMovies
        }
    }
}
