import XCTest
import Vapor
@testable import NovelCore

struct TestNodeValidator: NodeValidator {
  public let node: Node
  public var errors: [String: Node] = [:]

  public init(node: Node) {
    self.node = node
  }
}

class NodeValidationTests: XCTestCase {

  static let allTests = [
    ("testValidateBySuite", testValidateBySuite),
  ]

  var validator: NodeValidator!

  override func setUp() {
    super.setUp()
    let node = try! Node(node: ["firstname": "T", "lastname": "Test"])
    validator = TestNodeValidator(node: node)
  }

  // MARK: - Tests

  func testValidateBySuite() throws {
    validator.validate(key: "test", by: NameValidation.self)
    validator.validate(key: "firstname", by: NameValidation.self)
    validator.validate(key: "lastname", by: NameValidation.self)

    XCTAssertEqual(validator.errors["test"], "Field is missing")
    XCTAssertNotNil(validator.errors["firstname"])
    XCTAssertNil(validator.errors["lastname"])
    XCTAssertFalse(validator.isValid)

    validator.errors.removeAll()
    XCTAssertTrue(validator.isValid)
  }

  func testValidateByValidator() throws {
    validator.validate(key: "test", by: Count<String>.containedIn(low: 2, high: 100))
    validator.validate(key: "firstname", by: Count<String>.containedIn(low: 2, high: 100))
    validator.validate(key: "lastname", by: Count<String>.containedIn(low: 2, high: 100))

    XCTAssertEqual(validator.errors["test"], "Field is missing")
    XCTAssertNotNil(validator.errors["firstname"])
    XCTAssertNil(validator.errors["lastname"])
    XCTAssertFalse(validator.isValid)

    validator.errors.removeAll()
    XCTAssertTrue(validator.isValid)
  }
}
