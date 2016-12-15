import XCTest
import Fluent
@testable import NovelCore

class SessionTests: XCTestCase {

  typealias Key = Session.Key

  static let allTests = [
    ("testEntityName", testEntityName),
    ("testSetUser", testSetUser),
    ("testInitWhenValid", testInitWhenValid),
    ("testInitWhenInvalid", testInitWhenInvalid),
    ("testMakeNode", testMakeNode),
    ("testCreate", testCreate)
  ]

  var node: Node!
  var entity: Session!

  override func setUp() {
    super.setUp()

    node = try! Node(node: [
      Key.token.value : "token123",
      Key.userId.value: 1,
      ])

    entity = try! Session(node: node, in: EmptyNode)
  }

  // MARK: - Tests

  func testEntityName() throws {
    XCTAssertEqual(Session.entityName, "sessions")
  }

  func testSetUser() throws {
    let user = try createUser()
    user.id = 2
    entity.set(user: user)
    XCTAssertEqual(entity.userId, 2)
  }

  func testInitWhenValid() throws {
    XCTAssertEqual(entity.token, "token123")
    XCTAssertEqual(entity.userId, 1)
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

    XCTAssertEqual(result.object?.count, 2)
    XCTAssertEqual(result[Key.token.value], "token123")
    XCTAssertEqual(result[Key.userId.value], 1)
  }

  func testCreate() throws {
    let schema = Schema.Creator("session")
    try Session.create(schema: schema)

    XCTAssertEqual(schema.fields.count, 2)
    testField(in: schema, index: 0, name: Key.token.value, type: .string(length: nil), unique: true)
    testField(in: schema, index: 1, name: Key.userId.value, type: .int)
  }
}
