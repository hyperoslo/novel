import Vapor
import Fluent

public final class Entry: Model {

  public static let entityName = "entries"

  public enum Key: String {
    case id
    case slug
    case createdAt
    case updatedAt
    case publishedAt
    case chapterId
  }

  public var exists: Bool = false

  // Fields
  public var id: Node?
  public var slug: String
  public var createdAt: Int
  public var updatedAt: Int
  public var publishedAt: Int

  // Relations
  public var chapterId: Node?

  func chapter() throws -> Parent<Chapter> {
    return try parent(chapterId)
  }

  func set(chapter: Chapter) {
    chapterId = chapter.id
  }

  /**
    Initializer.
   */
  public init(node: Node, in context: Context) throws {
    id = node[Key.id.value]
    slug = try node.extract(Key.slug.value)
    createdAt = try node.extract(Key.createdAt.value)
    updatedAt = try node.extract(Key.updatedAt.value)
    publishedAt = try node.extract(Key.publishedAt.value)
    chapterId = node[Key.chapterId.value]
  }

  /**
   Fluent serialization.
   */
  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      Key.id.value: id,
      Key.slug.value: slug,
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
      users.string(Key.slug.value, length: 100)
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