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
    titanInstance.addFunction(respondToPreflightAllowingAllMethods)
    titanInstance.addFunction(allowAllOrigins)
    TitanCORS.addInsecureCORSSupport(titanInstance)
  }

  func testTitanCanRespondToPreflight() {
    titanInstance.addFunction(respondToPreflightAllowingAllMethods)

    let res = titanInstance.app(request: Request(method: "OPTIONS",
                                                 path: "/onuhoenth",
                                                 body: "",
                                                 headers: [
      ("Access-Control-Request-Method", "POST"),
      ("Access-Control-Request-Headers", "X-Custom-Header")
    ]))
    XCTAssertEqual(res.code, 200)
    XCTAssertEqual(res.body, "")

    XCTAssertEqual(res.retrieveHeaderByName("access-control-allow-methods").value.lowercased(), "post")
    XCTAssertEqual(res.retrieveHeaderByName("access-control-allow-headers").value.lowercased(), "x-custom-header")
  }

  func testTitanCanAllowAllOrigins() {
    titanInstance.addFunction(allowAllOrigins)
    let res = titanInstance.app(request: Request(method: "ANYMETHOD",
                                                 path: "NOT EVEN A REAL PATH",
                                                 body: "WOWOIE", headers: []))
    XCTAssertEqual(res.retrieveHeaderByName("access-control-allow-origin").value, "*")
  }
}

extension ResponseType {
  func retrieveHeaderByName(_ name: String) -> Header {
    guard let header = self.headers.first(where: { (hname, _) -> Bool in
      return hname.lowercased() == name.lowercased()
    }) else {
      XCTFail("Header \(name) not found")
      fatalError()
    }
    return header
  }
}
