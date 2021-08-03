import XCTest
@testable import MoviesAssessment

class MoviesAssessmentTests: XCTestCase {

    let data = MockedDataResponse.response.data(using: .utf8)!
      
    let request = GetAllMoviesRequest()
    func testRequestSuccess() throws {
     
      do {
        let result = try request.handle(response: data)
        XCTAssertEqual(result.movies.count, 2)
      } catch let decodingError as DecodingError {
        XCTFail((decodingError as CustomDebugStringConvertible).debugDescription)
      } catch let error {
        XCTFail(error.localizedDescription)
      }
    }
    func testRequestFailure() throws {
        do {
          let result = try request.handle(response: data)
            XCTAssertNotEqual(result.movies.count, 0)
        } catch let decodingError as DecodingError {
          XCTFail((decodingError as CustomDebugStringConvertible).debugDescription)
        } catch let error {
          XCTFail(error.localizedDescription)
        }
    }

}
