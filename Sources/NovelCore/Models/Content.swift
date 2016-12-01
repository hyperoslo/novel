import Vapor
import Fluent

public final class Content: Model {

  public enum Key: String {
    case id
    case body
    case fieldId
    case entryId
  }

  public var exists: Bool = false

  // Fields
  public var id: Node?
  public var body: String

  // Relations
  public var fieldId: Node?
  public var entryId: Node?

  /**
   Initializer.
   */
  public init(node: Node, in context: Context) throws {
    id = node[Key.id.snaked]
    body = try node.extract(Key.body.snaked)
    fieldId = node[Key.fieldId.snaked]
    entryId = node[Key.entryId.snaked]
  }

  /**
   Serialization.
   */
  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      Key.id.snaked: id,
      Key.body.snaked: body,
      Key.fieldId.snaked: fieldId,
      Key.entryId.snaked: entryId
      ])
  }
}

// MARK: - Preparations

extension Content {

  public static func prepare(_ database: Database) throws {
    try database.create(Content.entity) { entities in
      entities.id()
      entities.string(Key.body.snaked)
      entities.parent(Field.self, optional: false)
      entities.parent(Entry.self, optional: false)
    }
  }

  public static func revert(_ database: Database) throws {
    try database.delete(Content.entity)
  }
}
