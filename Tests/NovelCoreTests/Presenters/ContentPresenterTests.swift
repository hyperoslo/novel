import XCTest
import Vapor
import Fluent
@testable import NovelCore

class ContentPresenterTests: XCTestCase {

  static let allTests = [
    ("testMakeNodeWithField", testMakeNodeWithField),
    ("testMakeNodeWithoutField", testMakeNodeWithoutField)
  ]

  var presenter: ContentPresenter!

  override func setUp() {
    super.setUp()
    Content.database = Database(MemoryDriver())
    Field.database = Database(MemoryDriver())
  }

  override func tearDown() {
    super.tearDown()
    Content.database = nil
    Field.database = nil
  }

  // MARK: - Tests

  func testMakeNodeWithField() throws {
    var field = try! createField()
    try field.save()

    var content = try! createContent()
    content.set(field: field)
    try content.save()

    presenter = ContentPresenter(model: content)
    let node = try presenter.makeNode()

    XCTAssertEqual(node["id"], content.id)
    XCTAssertEqual(node["body"]?.string, content.body)
    XCTAssertNotNil(node["field"])
    XCTAssertEqual(node["field"]?["id"], field.id)
    XCTAssertEqual(node["field"]?["kind"]?.int, field.kind)
    XCTAssertEqual(node["field"]?["name"]?.string, field.name)
    XCTAssertEqual(node["field"]?["handle"]?.string, field.handle)
    XCTAssertEqual(node["field"]?["isRequired"]?.bool, field.isRequired)
    XCTAssertEqual(node["field"]?["minLength"]?.int, field.minLength)
    XCTAssertEqual(node["field"]?["maxLength"]?.int, field.maxLength)

    try content.delete()
    try field.delete()
  }

  func testMakeNodeWithoutField() throws {
    var content = try! createContent()
    try content.save()

    presenter = ContentPresenter(model: content)
    let node = try presenter.makeNode()

    XCTAssertEqual(node["id"], content.id)
    XCTAssertEqual(node["body"]?.string, content.body)
    XCTAssertNil(node["field"])

    try content.delete()
  }
}
