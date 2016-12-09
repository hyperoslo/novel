import Vapor
import Fluent

public final class Prototype: Model {

  public enum Key: String {
    case id
    case name
    case handle
    case description
  }

  // Fields
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
  public required init(node: Node, in context: Context) throws {
    name = try node.extract(Key.name.value)
    handle = try node.extract(Key.handle.value)
    description = node[Key.description.value]?.string ?? ""
    try super.init(node: node, in: context)
    validator = PrototypeValidator.self
  }

  /**
    Serialization.
   */
  public override func makeNode() throws -> Node {
    return try Node(node: [
      Key.name.value: name,
      Key.handle.value: handle,
      Key.description.value: description
      ])
  }

  /**
   Preparation.
   */
  public override class func create(schema: Schema.Creator) throws {
    schema.string(Key.name.value, length: 50)
    schema.string(Key.handle.value, length: 50, unique: true)
    schema.string(Key.description.value)
  }
}

// MARK: - Helpers

extension Prototype {

  public static func new() throws -> Prototype {
    let node = try Node(node: [
      Key.name.value: "",
      Key.handle.value: ""])

    return try Prototype(node: node)
  }

  public static func find(handle: String) throws -> Prototype? {
    return try Prototype.query().filter(Prototype.Key.handle.value, handle).first()
  }
}
