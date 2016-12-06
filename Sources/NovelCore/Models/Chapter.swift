import Vapor
import Fluent

public final class Chapter: Model {

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

  public func fields() -> Children<Field> {
    return children()
  }

  public func entries() -> Children<Entry> {
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
    try database.create(Chapter.entity) { entities in
      entities.id()
      entities.string(Key.name.value, length: 50)
      entities.string(Key.handle.value, length: 50)
      entities.string(Key.description.value)
    }
  }

  public static func revert(_ database: Database) throws {
    try database.delete(Chapter.entity)
  }
}

// MARK: - Validations

extension Chapter {

  public func validate() throws {
    let node = try makeNode()
    let validator = ChapterValidator(node: node)

    if !validator.isValid {
      throw InputError(data: node, errors: validator.errors)
    }
  }
}

// MARK: - Helpers

extension Chapter {

  public static func new() throws -> Chapter {
    let node = try Node(node: [
      Key.name.value: "",
      Key.handle.value: ""])

    return try Chapter(node: node)
  }
}
