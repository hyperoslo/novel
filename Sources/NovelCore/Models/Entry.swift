import Vapor
import Fluent

public protocol Model: Vapor.Model {
  func validate() throws
}

extension Model {

  public func updated(from node: Node) throws -> Self {
    var updatedNode = try makeNode()
    updatedNode.merge(with: node)

    return try Self(node: updatedNode)
  }
}

public final class Entry: Model {

  public static let entityName = "entries"

  public static var entity: String {
    return "entries"
  }

  public enum Key: String {
    case id
    case title
    case createdAt
    case updatedAt
    case publishedAt
    case chapterId
  }

  public var exists: Bool = false

  // Fields
  public var id: Node?
  public var title: String
  public var createdAt: Int
  public var updatedAt: Int
  public var publishedAt: Int

  // Relations
  public var chapterId: Node?

  public func chapter() throws -> Parent<Chapter> {
    return try parent(chapterId)
  }

  public func set(chapter: Chapter) {
    chapterId = chapter.id
  }

  public func contents() -> Children<Content> {
    return children()
  }

  /**
    Initializer.
   */
  public init(node: Node, in context: Context) throws {
    id = node[Key.id.value]
    title = node[Key.title.value]?.string ?? ""
    createdAt = node[Key.createdAt.value]?.int ?? 0
    updatedAt = node[Key.updatedAt.value]?.int ?? 0
    publishedAt = node[Key.publishedAt.value]?.int ?? 0
    chapterId = node[Key.chapterId.value]
  }

  /**
   Fluent serialization.
   */
  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      Key.id.value: id,
      Key.title.value: title,
      Key.createdAt.value: createdAt,
      Key.updatedAt.value: updatedAt,
      Key.publishedAt.value: publishedAt,
      Key.chapterId.value: chapterId,
    ])
  }
}

// MARK: - Preparations

extension Entry {

  public static func prepare(_ database: Database) throws {
    try database.create(Entry.entityName) { users in
      users.id()
      users.string(Key.title.value, length: 100)
      users.int(Key.createdAt.value)
      users.int(Key.updatedAt.value)
      users.int(Key.publishedAt.value)
      users.parent(Chapter.self, optional: false)
    }
  }

  public static func revert(_ database: Database) throws {
    try database.delete(Entry.entityName)
  }
}

// MARK: - Validations

extension Entry {

  public func validate() throws {
    let node = try makeNode()
    let validator = EntryValidator(node: node)

    if !validator.isValid {
      throw InputError(data: node, errors: validator.errors)
    }
  }
}

// MARK: - Helpers

extension Entry {

  public static func new() throws -> Entry {
    let node = try Node(node: [
      Key.title.value: "",
      Key.createdAt.value: 0,
      Key.updatedAt.value: 0,
      Key.publishedAt.value: 0
    ])

    return try Entry(node: node)
  }
}
