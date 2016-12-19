import XCTest
import Vapor
import HTTP
@testable import NovelCore

struct TestResponder: Responder {
  func respond(to request: Request) throws -> Response {
    return "test".makeResponse()
  }
}

class FallbackMiddlewareTests: XCTestCase {

  static let allTests = [
    ("testRespondWhenAllowed", testRespondWhenAllowed),
    ("testRespondWhenNotAllowed", testRespondWhenNotAllowed),
  ]

  var middleware: FallbackMiddleware!

  override func setUp() {
    super.setUp()
    middleware = FallbackMiddleware(fallback: "/auth") { request -> Bool in
      return request.method == .get
    }
  }

  // MARK: - Tests

  func testRespondWhenAllowed() throws {
    let request = try Request(method: .get, uri: "http://hyper.no")
    let responder = TestResponder()
    let result = try middleware.respond(to: request, chainingTo: responder)
    XCTAssertEqual(result.headers["Content-Type"], "text/plain; charset=utf-8")
  }

  func testRespondWhenNotAllowed() throws {
    let request = try Request(method: .post, uri: "http://hyper.no")
    let responder = TestResponder()
    let result = try middleware.respond(to: request, chainingTo: responder)
    XCTAssertEqual(result.headers["Location"], "/auth")
  }
}
