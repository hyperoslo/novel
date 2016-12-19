import Vapor
import Fluent

public final class Session: Model {

  public enum Key: String {
    case token
    case userId
  }

  // Fields
  public var token: String

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
  public required init(node: Node, in context: Context) throws {
    token = try node.extract(Key.token.value)
    userId = node[Key.userId.value]
    try super.init(node: node, in: context)
  }

  /**
   Serialization.
   */
  public override func makeNode() throws -> Node {
    return try Node(node: [
      Key.token.value: token,
      Key.userId.value: userId,
      ])
  }

  /**
   Preparation.
   */
  public override class func create(schema: Schema.Creator) throws {
    schema.string(Key.token.value, unique: true)
    schema.parent(User.self, optional: false)
  }
}
