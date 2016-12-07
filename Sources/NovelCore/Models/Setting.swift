import Foundation
import Vapor
import Fluent

public final class Setting: Model {

  public enum Key: String {
    case name
    case handle
    case value
  }

  // Fields
  public var name: String
  public var handle: String
  public var value: String

  /**
   Initializer.
   */
  public required init(node: Node, in context: Context) throws {
    name = node[Key.name.value]?.string ?? ""
    handle = node[Key.handle.value]?.string ?? ""
    value = node[Key.value.value]?.string ?? ""
    try super.init(node: node, in: context)
    validator = SettingValidator.self
  }

  /**
   Serialization.
   */
  public override func makeNode() throws -> Node {
    return try Node(
      node: [
        Key.name.value: name,
        Key.handle.value: handle,
        Key.value.value: value
      ]
    )
  }

  /**
   Preparation.
   */
  public override class func create(schema: Schema.Creator) throws {
    schema.string(Key.name.value, length: 50)
    schema.string(Key.handle.value, length: 50)
    schema.string(Key.value.value)
  }
}

// MARK: - Helpers

extension Setting {

  public static func new() throws -> Setting {
    let node = try Node(node: [])
    return try Setting(node: node)
  }
}
