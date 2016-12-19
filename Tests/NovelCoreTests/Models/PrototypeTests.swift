import XCTest
import Fluent
@testable import NovelCore

class PrototypeTests: XCTestCase {

  typealias Key = Prototype.Key

  static let allTests = [
    ("testEntityName", testEntityName),
    ("testValidator", testValidator),
    ("testInitWhenValid", testInitWhenValid),
    ("testInitWhenInvalid", testInitWhenInvalid),
    ("testMakeNode", testMakeNode),
    ("testCreate", testCreate),
    ("testNew", testNew)
  ]

  var entity: Prototype!

  override func setUp() {
    super.setUp()
    entity = try! createPrototype()
  }

  // MARK: - Tests

  func testEntityName() throws {
    XCTAssertEqual(Prototype.entityName, "prototypes")
  }

  func testValidator() {
    XCTAssertNotNil(entity.validator)
  }

  func testInitWhenValid() throws {
    XCTAssertEqual(entity.name, "Post")
    XCTAssertEqual(entity.handle, "post")
    XCTAssertEqual(entity.description, "Text")
  }

  func testInitWhenInvalid() throws {
    let node = try! Node(node: [])

    do {
      _ = try Prototype(node: node, in: EmptyNode)
      XCTFail("Init must fail with error")
    } catch {
      XCTAssertTrue(error is NodeError)
    }
  }

  func testMakeNode() throws {
    let result = try entity.makeNode()

    XCTAssertEqual(result.object?.count, 3)
    XCTAssertEqual(result[Key.name.value], "Post")
    XCTAssertEqual(result[Key.handle.value], "post")
    XCTAssertEqual(result[Key.description.value], "Text")
  }

  func testCreate() throws {
    let schema = Schema.Creator("prototypes")
    try Prototype.create(schema: schema)

    XCTAssertEqual(schema.fields.count, 3)
    testField(in: schema, index: 0, name: Key.name.value, type: .string(length: 50))
    testField(in: schema, index: 1, name: Key.handle.value, type: .string(length: 50), unique: true)
    testField(in: schema, index: 2, name: Key.description.value, type: .string(length: nil))
  }

  func testNew() throws {
    let entity = try Prototype.new()
    XCTAssertEqual(entity.name, "")
    XCTAssertEqual(entity.handle, "")
    XCTAssertEqual(entity.description, "")
  }
}
