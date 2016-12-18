import XCTest
import Vapor
import Fluent
@testable import NovelCore

class EntryPresenterTests: XCTestCase {

  static let allTests = [
    ("testMakeNode", testMakeNode)
  ]

  var presenter: EntryPresenter!

  override func setUp() {
    super.setUp()
    Entry.database = Database(MemoryDriver())
    Prototype.database = Database(MemoryDriver())
    Field.database = Database(MemoryDriver())
    Content.database = Database(MemoryDriver())
  }

  override func tearDown() {
    super.tearDown()
    Entry.database = nil
    Prototype.database = nil
    Field.database = nil
    Content.database = nil
  }

  // MARK: - Tests

  func testMakeNode() throws {
    var prototype = try createPrototype()
    try prototype.save()

    var field = try createField()
    field.set(prototype: prototype)
    try field.save()

    var entry = try createEntry()
    entry.set(prototype: prototype)
    try entry.save()

    var content = try createContent()
    content.set(field: field)
    content.set(entry: entry)
    try content.save()

    presenter = EntryPresenter(model: entry)
    let node = try presenter.makeNode()

    XCTAssertEqual(node["id"], entry.id)
    XCTAssertEqual(node["title"]?.string, entry.title)
    XCTAssertEqual(node["createdAt"]?.string, entry.createdAt.iso8601)
    XCTAssertEqual(node["updatedAt"]?.string, entry.updatedAt.iso8601)
    XCTAssertEqual(node["publishedAt"]?.string, entry.publishedAt.iso8601)

    XCTAssertNotNil(node["prototype"])
    XCTAssertEqual(node["prototype"]?["id"], prototype.id)
    XCTAssertEqual(node["prototype"]?["name"]?.string, prototype.name)
    XCTAssertEqual(node["prototype"]?["handle"]?.string, prototype.handle)
    XCTAssertEqual(node["prototype"]?["description"]?.string, prototype.description)

    XCTAssertNotNil(node["fields"])
    XCTAssertEqual(node["fields"]?.nodeArray?.count, 1)
    XCTAssertEqual(node["fields"]?[0]?["id"], field.id)
    XCTAssertEqual(node["fields"]?[0]?["kind"]?.int, field.kind)
    XCTAssertEqual(node["fields"]?[0]?["name"]?.string, field.name)
    XCTAssertEqual(node["fields"]?[0]?["handle"]?.string, field.handle)
    XCTAssertEqual(node["fields"]?[0]?["body"]?.string, content.body)
    XCTAssertEqual(node["fields"]?[0]?["isRequired"]?.bool, field.isRequired)
    XCTAssertEqual(node["fields"]?[0]?["minLength"]?.int, field.minLength)
    XCTAssertEqual(node["fields"]?[0]?["maxLength"]?.int, field.maxLength)

    try prototype.delete()
    try field.delete()
    try entry.delete()
    try content.delete()
  }
}
