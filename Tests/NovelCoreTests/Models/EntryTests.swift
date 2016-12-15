import XCTest
import Fluent
@testable import NovelCore

class EntryTests: XCTestCase {

  typealias Key = Entry.Key

  static let allTests = [
    ("testEntityName", testEntityName),
    ("testValidator", testValidator),
    ("testSetPrototype", testSetPrototype),
    ("testInitWhenValid", testInitWhenValid),
    ("testInitWhenInvalid", testInitWhenInvalid),
    ("testMakeNode", testMakeNode),
    ("testCreate", testCreate),
    ("testNew", testNew)
  ]

  let dateString = "2016-12-01 23:01:00"
  var node: Node!
  var entity: Entry!

  override func setUp() {
    super.setUp()

    node = try! Node(node: [
      Key.title.value : "Title",
      Key.publishedAt.value: dateString,
      Key.prototypeId.value: 1,
      ])

    entity = try! Entry(node: node, in: EmptyNode)
  }

  // MARK: - Tests

  func testEntityName() throws {
    XCTAssertEqual(Entry.entityName, "entries")
  }

  func testValidator() {
    XCTAssertNotNil(entity.validator)
  }

  func testSetPrototype() throws {
    let prototype = try Prototype.new()
    prototype.id = 2
    entity.set(prototype: prototype)
    XCTAssertEqual(entity.prototypeId, 2)
  }

  func testInitWhenValid() throws {
    XCTAssertEqual(entity.title, "Title")
    XCTAssertEqual(entity.publishedAt.iso8601, dateString)
    XCTAssertEqual(entity.prototypeId, 1)
  }

  func testInitWhenInvalid() throws {
    let node = try! Node(node: [])
    let entity = try Entry(node: node, in: EmptyNode)

    XCTAssertEqual(entity.title, "")
    XCTAssertNotNil(entity.publishedAt)
    XCTAssertNil(entity.prototypeId)
  }

  func testMakeNode() throws {
    let result = try entity.makeNode()

    XCTAssertEqual(result.object?.count, 3)
    XCTAssertEqual(result[Key.title.value], "Title")
    XCTAssertEqual(result[Key.publishedAt.value], dateString.makeNode())
    XCTAssertEqual(result[Key.prototypeId.value], 1)
  }

  func testCreate() throws {
    let schema = Schema.Creator("entries")
    try Entry.create(schema: schema)

    XCTAssertEqual(schema.fields.count, 3)
    testField(in: schema, index: 0, name: Key.title.value, type: .string(length: 100))
    testField(in: schema, index: 1, name: Key.publishedAt.value, type: .custom(type: "timestamp"))
    testField(in: schema, index: 2, name: Key.prototypeId.value, type: .int)
  }

  func testNew() throws {
    let entity = try Entry.new()
    XCTAssertEqual(entity.title, "")
    XCTAssertNotNil(entity.publishedAt)
    XCTAssertNil(entity.prototypeId)
  }
}
