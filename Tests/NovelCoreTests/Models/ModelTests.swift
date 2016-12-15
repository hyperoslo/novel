import XCTest
import Fluent
@testable import NovelCore

class ModelTests: XCTestCase {

  typealias Required = Model.Required

  static let allTests = [
    ("testEntity", testEntity),
    ("testExists", testExists),
    ("testInitWhenValid", testInitWhenValid),
    ("testInitWhenInvalid", testInitWhenInvalid),
    ("testMakeNodeContext", testMakeNodeContext),
    ("testMakeNode", testMakeNode),
    ("testPrepareDatabase", testPrepareDatabase),
    ("testCreate", testCreate),
    ("testPrepareSchema", testPrepareSchema),
    ("testPrepareSchema", testValidateWhenInvalid),
    ("testPrepareSchema", testUpdatedWhenExists),
    ("testPrepareSchema", testUpdatedWhenNotExist)
  ]

  var node: Node!
  var entity: Model!
  let dateString = "2016-12-01 23:01:00"

  override func setUp() {
    super.setUp()

    node = try! Node(node: [
      Required.id.value : 1,
      Required.createdAt.value: dateString,
      Required.updatedAt.value: dateString,
      ])

    entity = try! Model(node: node, in: EmptyNode)
  }

  // MARK: - Tests

  func testEntity() throws {
    XCTAssertEqual(Model.entity, Model.entityName)
  }

  func testExists() throws {
    XCTAssertFalse(entity.exists)
  }

  func testInitWhenValid() throws {
    XCTAssertEqual(entity.id, 1)
    XCTAssertEqual(entity.createdAt.iso8601, dateString)
    XCTAssertEqual(entity.updatedAt.iso8601, dateString)
  }

  func testInitWhenInvalid() throws {
    let node = try! Node(node: [])
    let entity = try Model(node: node, in: EmptyNode)

    XCTAssertNil(entity.id)
    XCTAssertNotNil(entity.createdAt)
    XCTAssertNotNil(entity.updatedAt)
  }

  func testMakeNodeContext() throws {
    let result = try entity.makeNode(context: EmptyNode)

    XCTAssertEqual(result.object?.count, 3)
    XCTAssertEqual(result[Required.id.value], 1)
    XCTAssertEqual(result[Required.createdAt.value], dateString.makeNode())
    XCTAssertEqual(result[Required.updatedAt.value], dateString.makeNode())
  }

  func testMakeNode() throws {
    let result = try entity.makeNode()
    XCTAssertNil(result.object)
  }

  func testPrepareDatabase() throws {
    do {
      let database = Database(MemoryDriver())
      try Model.prepare(database)
    } catch {
      XCTAssertTrue(error is Model.ModelError)
    }
  }

  func testCreate() throws {
    do {
      let schema = Schema.Creator("models")
      try Model.create(schema: schema)
    } catch {
      XCTAssertTrue(error is Model.ModelError)
    }
  }

  func testPrepareSchema() throws {
    let schema = Schema.Creator("models")
    try Model.prepare(schema: schema)

    XCTAssertEqual(schema.fields.count, 3)
    testField(in: schema, index: 0, name: Required.id.value, type: .id, unique: true)
    testField(in: schema, index: 1, name: Required.createdAt.value, type: .custom(type: "timestamp"))
    testField(in: schema, index: 2, name: Required.updatedAt.value, type: .custom(type: "timestamp"))
  }

  func testValidateWhenInvalid() throws {
    let entity = try createUser()
    entity.username = ""

    do {
      try entity.validate()
    } catch {
      XCTAssertTrue(error is InputError)
      XCTAssertEqual((error as? InputError)?.data.object?.count, try entity.makeNode().object?.count)
      XCTAssertNotNil((error as? InputError)?.errors["username"])
    }
  }

  func testUpdatedWhenExists() throws {
    let entity = try! Model(node: node, in: EmptyNode)
    let updateNode = try! Node(node: [
      Required.id.value : 2
      ])
    let result = try entity.updated(from: updateNode, exists: true)

    XCTAssertTrue(result.exists)
    XCTAssertEqual(result.id, 2)
    XCTAssertEqual(result.createdAt.iso8601, entity.createdAt.iso8601)
    XCTAssertEqual(result.updatedAt.iso8601, entity.updatedAt.iso8601)
  }

  func testUpdatedWhenNotExist() throws {
    let entity = try! Model(node: node, in: EmptyNode)
    let updateNode = try! Node(node: [
      Required.id.value : 2
      ])
    let result = try entity.updated(from: updateNode, exists: false)

    XCTAssertFalse(result.exists)
    XCTAssertEqual(result.id, 2)
    XCTAssertEqual(result.createdAt.iso8601, entity.createdAt.iso8601)
    XCTAssertEqual(result.updatedAt.iso8601, entity.updatedAt.iso8601)
  }
}
