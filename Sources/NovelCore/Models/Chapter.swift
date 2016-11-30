import Vapor
import Fluent

public final class Chapter: Model {

  public static let entityName = "chapters"

  public enum Key: String {
    case id
    case name
    case handle
    case description
  }

  public var exists: Bool = false

  // Fields
  public var id: Node?
  public var name: String
  public var handle: String
  public var description: String

  // Relations

  func fields() -> Children<Field> {
    return children()
  }

  func entries() -> Children<Entry> {
    return children()
  }

  /**
    Initializer.
   */
  public init(node: Node, in context: Context) throws {
    id = node[Key.id.value]
    name = try node.extract(Key.name.value)
    handle = try node.extract(Key.handle.value)
    description = node[Key.description.value]?.string ?? ""
  }

  /**
    Serialization.
   */
  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      Key.id.value: id,
      Key.name.value: name,
      Key.handle.value: handle,
      Key.description.value: description
      ])
  }
}

// MARK: - Preparations

extension Chapter {

  public static func prepare(_ database: Database) throws {
    try database.create(Chapter.entityName) { entities in
      entities.id()
      entities.string(Key.name.value, length: 50)
      entities.string(Key.handle.value, length: 50)
      entities.string(Key.description.value)
    }
  }

  public static func revert(_ database: Database) throws {
    try database.delete(Chapter.entityName)
  }
}
