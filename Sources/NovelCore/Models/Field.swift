import Vapor
import Fluent

public final class Field: Model {

  public enum Key: String {
    case id
    case kind
    case name
    case handle
    case isRequired
    case minLength
    case maxLength
    case prototypeId
  }

  // Fields
  public var kind: Int
  public var name: String
  public var handle: String
  public var isRequired: Bool?
  public var minLength: Int?
  public var maxLength: Int?

  // Relations
  public var prototypeId: Node?

  public func prototype() throws -> Parent<Prototype> {
    return try parent(prototypeId)
  }

  public func set(prototype: Prototype) {
    prototypeId = prototype.id
  }

  /**
   Fluent initializer.
   */
  public required init(node: Node, in context: Context) throws {
    kind = try node.extract(Key.kind.value)
    name = try node.extract(Key.name.value)
    handle = try node.extract(Key.handle.value)
    isRequired = try? node.extract(Key.isRequired.value)
    minLength = try? node.extract(Key.minLength.value)
    maxLength = try? node.extract(Key.maxLength.value)
    prototypeId = node[Key.prototypeId.value]
    try super.init(node: node, in: context)
    validator = FieldValidator.self
  }

  /**
   Serialization.
   */
  public override func makeNode() throws -> Node {
    return try Node(node: [
      Key.kind.value: kind,
      Key.name.value: name,
      Key.handle.value: handle,
      Key.isRequired.value: isRequired,
      Key.minLength.value: minLength,
      Key.maxLength.value: maxLength,
      Key.prototypeId.value: prototypeId
      ])
  }

  /**
   Preparation.
   */
  public override class func create(schema: Schema.Creator) throws {
    schema.int(Key.kind.value)
    schema.string(Key.name.value, length: 50)
    schema.string(Key.handle.value, length: 50)
    schema.bool(Key.isRequired.value, optional: true)
    schema.int(Key.minLength.value, optional: true)
    schema.int(Key.maxLength.value, optional: true)
    schema.parent(Prototype.self, optional: false)
  }
}

// MARK: - Helpers

extension Field {

  public static func new() throws -> Field {
    let node = try Node(node: [
      Key.kind.value: FieldKind.plainText.rawValue,
      Key.name.value: "",
      Key.handle.value: ""])

    return try Field(node: node)
  }
}
