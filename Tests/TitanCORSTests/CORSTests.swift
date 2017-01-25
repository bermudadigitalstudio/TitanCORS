import TitanCORS
import TitanCore
import XCTest

final class CORSTests: XCTestCase {
  var titanInstance: Titan!
  override func setUp() {
    titanInstance = Titan()
  }
  override func tearDown() {
    titanInstance = nil
  }
  func testCanAddCorsFunctionToTitan() {
    titanInstance.addFunction(RespondToPreflight)
    titanInstance.addFunction(AllowAllOrigins)
  }
}
