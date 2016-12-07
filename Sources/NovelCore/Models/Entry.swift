import Vapor
import Fluent

public final class Entry: Model {

  public static var entity: String {
    return "entries"
  }

  public enum Key: String {
    case id
    case title
    case createdAt
    case updatedAt
    case publishedAt
    case prototypeId
  }

  // Fields
  public var title: String
  public var publishedAt: Int

  // Relations
  public var prototypeId: Node?

  public func prototype() throws -> Parent<Prototype> {
    return try parent(prototypeId)
  }

  public func set(prototype: Prototype) {
    prototypeId = prototype.id
  }

  public func contents() -> Children<Content> {
    return children()
  }

  /**
    Initializer.
   */
  public required init(node: Node, in context: Context) throws {
    title = node[Key.title.value]?.string ?? ""
    publishedAt = node[Key.publishedAt.value]?.int ?? 0
    prototypeId = node[Key.prototypeId.value]
    try super.init(node: node, in: context)
    validator = EntryValidator.self
  }

  /**
    Serialization.
   */
  public override func makeNode() throws -> Node {
    return try Node(node: [
      Key.title.value: title,
      Key.publishedAt.value: publishedAt,
      Key.prototypeId.value: prototypeId,
    ])
  }

  /**
   Preparation.
   */
  public override class func create(schema: Schema.Creator) throws {
    schema.string(Key.title.value, length: 100)
    schema.int(Key.publishedAt.value)
    schema.parent(Prototype.self, optional: false)
  }
}

// MARK: - Helpers

extension Entry {

  public static func new() throws -> Entry {
    let node = try Node(node: [
      Key.title.value: "",
      Key.publishedAt.value: 0
    ])

    return try Entry(node: node)
  }
}
