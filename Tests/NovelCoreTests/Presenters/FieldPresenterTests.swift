import XCTest
import Vapor
import Fluent
@testable import NovelCore

class FieldPresenterTests: XCTestCase {

  static let allTests = [
    ("testMakeNode", testMakeNode),
  ]

  var presenter: FieldPresenter!

  override func setUp() {
    super.setUp()
    Field.database = Database(MemoryDriver())
  }

  override func tearDown() {
    super.tearDown()
    Field.database = nil
  }

  // MARK: - Tests

  func testMakeNode() throws {
    var field = try createField()
    try field.save()
    presenter = FieldPresenter(model: field)
    let node = try presenter.makeNode()

    XCTAssertEqual(node["id"], field.id)
    XCTAssertEqual(node["kind"]?.int, field.kind)
    XCTAssertEqual(node["name"]?.string, field.name)
    XCTAssertEqual(node["handle"]?.string, field.handle)
    XCTAssertEqual(node["isRequired"]?.bool, field.isRequired)
    XCTAssertEqual(node["minLength"]?.int, field.minLength)
    XCTAssertEqual(node["maxLength"]?.int, field.maxLength)

    try field.delete()
  }
}
