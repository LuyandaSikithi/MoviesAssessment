import Foundation
import XCTest
@testable import MoviesAssessment

class ConstantsTest: XCTestCase {
    func testConstance() {
        XCTAssertEqual(Constants.dateFormat, "yyyy-mm-dd'T'HH:mm:ss")
        XCTAssertEqual(Constants.failedRequest, "Sorry there is a problem with the service. Please check your connection.")
        XCTAssertEqual(Constants.noMovies, "Sorry we do not have that movie. Please search for a different movie.")
        XCTAssertEqual(Constants.secrete.authKey, "Authorization")
        XCTAssertEqual(Constants.secrete.authValue, "Bearer Wookie2019")
        XCTAssertEqual(Constants.secrete.baseUrl, "https://wookie.codesubmit.io")
        
        XCTAssertEqual(Constants.http.contentTypeJson, "application/json")
        XCTAssertEqual(Constants.http.pathMovies, "/movies")
        XCTAssertEqual(Constants.http.searchPath, "/movies?q=")
        
        XCTAssertEqual(Constants.Metrics.headerHeight60, 60)
        XCTAssertEqual(Constants.Metrics.horizontalStride20, 20)
        XCTAssertEqual(Constants.Metrics.height80, 80)
        XCTAssertEqual(Constants.Metrics.height10, 10)
        XCTAssertEqual(Constants.Metrics.width15, 15)
        XCTAssertEqual(Constants.Metrics.verticalStride2, 2)
    }
}
