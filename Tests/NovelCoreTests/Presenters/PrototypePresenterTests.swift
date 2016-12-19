import XCTest
import Vapor
import Fluent
@testable import NovelCore

class PrototypePresenterTests: XCTestCase {

  static let allTests = [
    ("testMakeNodeWithFields", testMakeNodeWithFields),
    ("testMakeNodeWithoutFields", testMakeNodeWithoutFields)
  ]

  var presenter: PrototypePresenter!

  override func setUp() {
    super.setUp()
    Prototype.database = Database(MemoryDriver())
    Field.database = Database(MemoryDriver())
  }

  override func tearDown() {
    super.tearDown()
    Prototype.database = nil
    Field.database = nil
  }

  // MARK: - Tests

  func testMakeNodeWithFields() throws {
    var prototype = try createPrototype()
    try prototype.save()

    var field = try createField()
    field.set(prototype: prototype)
    try field.save()

    presenter = PrototypePresenter(model: prototype)
    let node = try presenter.makeNode()

    XCTAssertEqual(node["id"], prototype.id)
    XCTAssertEqual(node["name"]?.string, prototype.name)
    XCTAssertEqual(node["handle"]?.string, prototype.handle)
    XCTAssertEqual(node["description"]?.string, prototype.description)

    XCTAssertNotNil(node["fields"])
    XCTAssertEqual(node["fields"]?.nodeArray?.count, 1)
    XCTAssertEqual(node["fields"]?[0]?["id"], field.id)
    XCTAssertEqual(node["fields"]?[0]?["kind"]?.int, field.kind)
    XCTAssertEqual(node["fields"]?[0]?["name"]?.string, field.name)
    XCTAssertEqual(node["fields"]?[0]?["handle"]?.string, field.handle)
    XCTAssertEqual(node["fields"]?[0]?["isRequired"]?.bool, field.isRequired)
    XCTAssertEqual(node["fields"]?[0]?["minLength"]?.int, field.minLength)
    XCTAssertEqual(node["fields"]?[0]?["maxLength"]?.int, field.maxLength)

    try prototype.delete()
    try field.delete()
  }

  func testMakeNodeWithoutFields() throws {
    var prototype = try createPrototype()
    try prototype.save()

    presenter = PrototypePresenter(model: prototype)
    let node = try presenter.makeNode()

    XCTAssertEqual(node["id"], prototype.id)
    XCTAssertEqual(node["name"]?.string, prototype.name)
    XCTAssertEqual(node["handle"]?.string, prototype.handle)
    XCTAssertEqual(node["description"]?.string, prototype.description)

    XCTAssertNotNil(node["fields"])
    XCTAssertEqual(node["fields"]?.nodeArray?.count, 0)

    try prototype.delete()
  }
}
