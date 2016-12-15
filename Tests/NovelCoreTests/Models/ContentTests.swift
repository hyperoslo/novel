import XCTest
import Fluent
@testable import NovelCore

class ContentTests: XCTestCase {

  typealias Key = Content.Key

  static let allTests = [
    ("testSetField", testSetField),
    ("testSetEntry", testSetEntry),
    ("testInitWhenValid", testInitWhenValid),
    ("testInitWhenInvalid", testInitWhenInvalid),
    ("testMakeNode", testMakeNode),
    ("testCreate", testCreate),
    ("testNew", testNew)
  ]

  var node: Node!
  var entity: Content!

  override func setUp() {
    super.setUp()

    node = try! Node(node: [
      Key.body.value : "Content",
      Key.fieldId.value: 1,
      Key.entryId.value: 1,
    ])

    entity = try! Content(node: node, in: EmptyNode)
  }

  // MARK: - Tests

  func testSetField() throws {
    let field = try Field.new()
    field.id = 2
    entity.set(field: field)
    XCTAssertEqual(entity.fieldId, 2)
  }

  func testSetEntry() throws {
    let entry = try Entry.new()
    entry.id = 2
    entity.set(entry: entry)
    XCTAssertEqual(entity.entryId, 2)
  }

  func testInitWhenValid() throws {
    XCTAssertEqual(entity.body, "Content")
    XCTAssertEqual(entity.fieldId, 1)
    XCTAssertEqual(entity.entryId, 1)
  }

  func testInitWhenInvalid() throws {
    let node = try! Node(node: [])
    let entity = try Content(node: node, in: EmptyNode)

    XCTAssertEqual(entity.body, "")
    XCTAssertNil(entity.fieldId)
    XCTAssertNil(entity.entryId)
  }

  func testMakeNode() throws {
    let result = try entity.makeNode()

    XCTAssertEqual(result.object?.count, 3)
    XCTAssertEqual(result[Key.body.value], "Content")
    XCTAssertEqual(result[Key.fieldId.value], 1)
    XCTAssertEqual(result[Key.entryId.value], 1)
  }

  func testCreate() throws {
    let schema = Schema.Creator("contents")
    try Content.create(schema: schema)

    XCTAssertEqual(schema.fields.count, 3)
    testField(in: schema, index: 0, name: Key.body.value, type: .string(length: nil))
    testField(in: schema, index: 1, name: Key.fieldId.value, type: .int)
    testField(in: schema, index: 2, name: Key.entryId.value, type: .int)
  }

  func testNew() throws {
    let entity = try Content.new()
    XCTAssertEqual(entity.body, "")
    XCTAssertNil(entity.fieldId)
    XCTAssertNil(entity.entryId)
  }
}
