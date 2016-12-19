import XCTest
import Fluent
@testable import NovelCore

class FieldTests: XCTestCase {

  typealias Key = Field.Key

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

  var entity: Field!

  override func setUp() {
    super.setUp()
    entity = try! createField()
  }

  // MARK: - Tests

  func testEntityName() throws {
    XCTAssertEqual(Field.entityName, "fields")
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
    XCTAssertEqual(entity.kind, FieldKind.plainText.rawValue)
    XCTAssertEqual(entity.name, "Title")
    XCTAssertEqual(entity.handle, "title")
    XCTAssertEqual(entity.isRequired, true)
    XCTAssertEqual(entity.minLength, 5)
    XCTAssertEqual(entity.maxLength, 20)
    XCTAssertEqual(entity.prototypeId, 1)
  }

  func testInitWhenInvalid() throws {
    let node = try! Node(node: [])

    do {
      _ = try Field(node: node, in: EmptyNode)
      XCTFail("Init must fail with error")
    } catch {
      XCTAssertTrue(error is NodeError)
    }
  }

  func testMakeNode() throws {
    let result = try entity.makeNode()

    XCTAssertEqual(result.object?.count, 7)
    XCTAssertEqual(result[Key.kind.value], try FieldKind.plainText.rawValue.makeNode())
    XCTAssertEqual(result[Key.name.value], "Title")
    XCTAssertEqual(result[Key.handle.value], "title")
    XCTAssertEqual(result[Key.isRequired.value], true)
    XCTAssertEqual(result[Key.minLength.value], 5)
    XCTAssertEqual(result[Key.maxLength.value], 20)
    XCTAssertEqual(result[Key.prototypeId.value], 1)
  }

  func testCreate() throws {
    let schema = Schema.Creator("fields")
    try Field.create(schema: schema)

    XCTAssertEqual(schema.fields.count, 7)
    testField(in: schema, index: 0, name: Key.kind.value, type: .int)
    testField(in: schema, index: 1, name: Key.name.value, type: .string(length: 50))
    testField(in: schema, index: 2, name: Key.handle.value, type: .string(length: 50))
    testField(in: schema, index: 3, name: Key.isRequired.value, type: .bool, default: false)
    testField(in: schema, index: 4, name: Key.minLength.value, type: .int, optional: true)
    testField(in: schema, index: 5, name: Key.maxLength.value, type: .int, optional: true)
    testField(in: schema, index: 6, name: Key.prototypeId.value, type: .int)
  }

  func testNew() throws {
    let entity = try Field.new()
    XCTAssertEqual(entity.kind, FieldKind.plainText.rawValue)
    XCTAssertEqual(entity.name, "")
    XCTAssertEqual(entity.handle, "")
    XCTAssertEqual(entity.isRequired, false)
    XCTAssertNil(entity.minLength)
    XCTAssertNil(entity.maxLength)
    XCTAssertNil(entity.prototypeId)
  }
}
