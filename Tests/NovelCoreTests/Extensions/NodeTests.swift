import XCTest
import Vapor
import HTTP
import Auth
@testable import NovelCore

class NodeTests: XCTestCase {

  static let allTests = [
    ("testMerge", testMerge),
  ]

  var node: Node!

  override func setUp() {
    super.setUp()
  }

  func testMerge() throws {
    node = try Node(node: ["key1": "value1", "key2": "value2"])
    let node2 = try Node(node: ["key1": "value2", "key3": "value3"])
    node.merge(with: node2)

    let object = node.nodeObject!
    XCTAssertEqual(object.count, 3)
    XCTAssertEqual(object["key1"], "value2")
    XCTAssertEqual(object["key2"], "value2")
    XCTAssertEqual(object["key3"], "value3")
  }
}
