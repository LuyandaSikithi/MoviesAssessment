import UIKit

struct Constants{
    static let title = "Wookie Movies"
    static let dateFormat = "yyyy-mm-dd'T'HH:mm:ss"
        
    static let failedRequest = "Sorry there is a problem with the service. Please check your connection."
    static let noMovies = "Sorry we do not have that movie. Please search for a different movie."
    
    enum secrete {
        static let authKey = "Authorization"
        static let authValue = "Bearer Wookie2019"
        static let baseUrl = "https://wookie.codesubmit.io"
    }
    
    enum http {
        static let contentTypeJson = "application/json"
        static let pathMovies = "/movies"
        static let searchPath = "/movies?q="
    }
    
    
    enum Metrics {
        static let headerHeight60: CGFloat = 60
        static let horizontalStride20: CGFloat = 20
        static let height80: CGFloat = 80
        static let height10: CGFloat = 10
        static let width15: CGFloat = 15
        static let verticalStride2: CGFloat = 2
    }
}
