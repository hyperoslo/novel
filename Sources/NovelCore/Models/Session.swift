import Vapor
import Fluent

public final class Session: Vapor.Model {

  public enum Key: String {
    case id
    case token
    case createdAt
    case updatedAt
    case userId
  }

  public var exists: Bool = false

  // Fields
  public var id: Node?
  public var token: String
  public var createdAt: Int
  public var updatedAt: Int

  // Relations
  public var userId: Node?

  public func user() throws -> Parent<User> {
    return try parent(userId)
  }

  public func set(user: User) {
    userId = user.id
  }

  /**
   Initializer.
   */
  public init(node: Node, in context: Context) throws {
    id = node[Key.id.value]
    token = try node.extract(Key.token.value)
    createdAt = try node.extract(Key.createdAt.value)
    updatedAt = try node.extract(Key.updatedAt.value)
    userId = node[Key.userId.value]
  }

  /**
   Fluent serialization.
   */
  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      Key.id.value: id,
      Key.token.value: token,
      Key.createdAt.value: createdAt,
      Key.updatedAt.value: updatedAt,
      Key.userId.value: userId,
      ])
  }
}

// MARK: - Preparations

extension Session {

  public static func prepare(_ database: Database) throws {
    try database.create(Session.entity) { users in
      users.id()
      users.string(Key.token.value)
      users.int(Key.createdAt.value)
      users.int(Key.updatedAt.value)
      users.parent(User.self, optional: false)
    }
  }

  public static func revert(_ database: Database) throws {
    try database.delete(Session.entity)
  }
}
