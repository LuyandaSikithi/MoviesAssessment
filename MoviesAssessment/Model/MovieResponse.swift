import Foundation
struct MovieResponse: Codable {
    var movies: [responseData]
}

struct responseData: Codable {
    var backdrop: String?
    var cast: [String]?
    var classification: String?
    var director: Director?
    var genres: [String]?
    var id: String?
    var imdb_rating: Double?
    var length: String?
    var overview: String?
    var poster: String?
    var released_on: String?
    var slug: String?
    var title: String?
}
enum Director: Codable {
    case string(String)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let director = try? container.decode([String].self) {
            self = .stringArray(director)
            return
        }
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }
        throw DecodingError.typeMismatch(Director.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Check type"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .stringArray(let value):
            try container.encode(value)
        }
    }
    

}
