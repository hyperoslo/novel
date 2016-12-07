import Vapor
import Fluent

public final class Setting: Model {

  public enum Key: String {
    case id
    case name
    case handle
    case value
  }

  public var exists: Bool = false

  // Fields
  public var id: Node?
  public var name: String
  public var handle: String
  public var value: String

  /**
   Initializer.
   */
  public init(node: Node, in context: Context) throws {
    id = node[Key.id.value]
    name = node[Key.name.value]?.string ?? ""
    handle = node[Key.handle.value]?.string ?? ""
    value = node[Key.value.value]?.string ?? ""
  }

  /**
   Serialization.
   */
  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      Key.id.value: id,
      Key.name.value: name,
      Key.handle.value: handle,
      Key.value.value: value
      ])
  }
}

// MARK: - Preparations

extension Setting {

  public static func prepare(_ database: Database) throws {
    try database.create(Setting.entity) { entities in
      entities.id()
      entities.string(Key.name.value, length: 50)
      entities.string(Key.handle.value, length: 50)
      entities.string(Key.value.value)
    }
  }

  public static func revert(_ database: Database) throws {
    try database.delete(Setting.entity)
  }
}

// MARK: - Validations

extension Setting {

  public func validate() throws {
    let node = try makeNode()
    let validator = ContentValidator(node: node)

    if !validator.isValid {
      throw InputError(data: node, errors: validator.errors)
    }
  }
}

// MARK: - Helpers

extension Setting {

  public static func new() throws -> Setting {
    let node = try Node(node: [])
    return try Setting(node: node)
  }
}
