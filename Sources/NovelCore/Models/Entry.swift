import Foundation
import Vapor
import Fluent

public final class Entry: Model {

  public override class var entityName: String {
    return "entries"
  }

  public enum Key: String {
    case title
    case publishedAt
    case prototypeId
  }

  // Fields
  public var title: String
  public var publishedAt: Date

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
    publishedAt = node[Key.publishedAt.value]?.string?.iso8601 ?? Date()
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
      Key.publishedAt.value: publishedAt.iso8601,
      Key.prototypeId.value: prototypeId,
    ])
  }

  /**
   Preparation.
   */
  public override class func create(schema: Schema.Creator) throws {
    schema.string(Key.title.value, length: 100)
    schema.timestamp(Key.publishedAt.value)
    schema.parent(Prototype.self, optional: false)
  }
}

// MARK: - Helpers

extension Entry {

  public static func new() throws -> Entry {
    let node = try Node(node: [
      Key.title.value: ""
    ])

    return try Entry(node: node)
  }
}
