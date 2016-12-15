import XCTest
import Fluent
@testable import NovelCore

class SettingTests: XCTestCase {

  typealias Key = Setting.Key

  static let allTests = [
    ("testGeneral", testGeneral),
    ("testInitWhenValid", testInitWhenValid),
    ("testInitWhenInvalid", testInitWhenInvalid),
    ("testMakeNode", testMakeNode),
    ("testCreate", testCreate)
  ]

  var node: Node!
  var entity: Setting!

  override func setUp() {
    super.setUp()

    node = try! Node(node: [
      Key.name.value : "Setting",
      Key.handle.value: "setting",
      Key.value.value: "Text",
      ])

    entity = try! Setting(node: node, in: EmptyNode)
  }

  // MARK: - Tests

  func testGeneral() throws {
    XCTAssertEqual(Setting.General.siteName.title, "Site name")
    XCTAssertEqual(Setting.General.siteUrl.title, "Site URL")
  }

  func testInitWhenValid() throws {
    XCTAssertEqual(entity.name, "Setting")
    XCTAssertEqual(entity.handle, "setting")
    XCTAssertEqual(entity.value, "Text")
  }

  func testInitWhenInvalid() throws {
    let node = try! Node(node: [])
    let entity = try Setting(node: node, in: EmptyNode)

    XCTAssertEqual(entity.name, "")
    XCTAssertEqual(entity.handle, "")
    XCTAssertEqual(entity.value, "")
  }

  func testMakeNode() throws {
    let result = try entity.makeNode()

    XCTAssertEqual(result.object?.count, 3)
    XCTAssertEqual(result[Key.name.value], "Setting")
    XCTAssertEqual(result[Key.handle.value], "setting")
    XCTAssertEqual(result[Key.value.value], "Text")
  }

  func testCreate() throws {
    let schema = Schema.Creator("settings")
    try Setting.create(schema: schema)

    XCTAssertEqual(schema.fields.count, 3)
    testField(in: schema, index: 0, name: Key.name.value, type: .string(length: 50))
    testField(in: schema, index: 1, name: Key.handle.value, type: .string(length: 50), unique: true)
    testField(in: schema, index: 2, name: Key.value.value, type: .string(length: nil))
  }

  func testNew() throws {
    let entity = try Setting.new()
    XCTAssertEqual(entity.name, "")
    XCTAssertEqual(entity.handle, "")
    XCTAssertEqual(entity.value, "")
  }
}
