import Vapor
import Fluent

public final class Content: Model {

  public enum Key: String {
    case body
    case fieldId
    case entryId
  }

  // Fields
  public var body: String

  // Relations
  public var fieldId: Node?
  public var entryId: Node?

  public func field() throws -> Parent<Field> {
    return try parent(fieldId)
  }

  public func set(field: Field) {
    fieldId = field.id
  }

  public func set(entry: Entry) {
    entryId = entry.id
  }

  /**
   Initializer.
   */
  public required init(node: Node, in context: Context) throws {
    body = node[Key.body.snaked]?.string ?? ""
    fieldId = node[Key.fieldId.snaked]
    entryId = node[Key.entryId.snaked]
    try super.init(node: node, in: context)
    validator = ContentValidator.self
  }

  /**
   Serialization.
   */
  public override func makeNode() throws -> Node {
    return try Node(node: [
      Key.body.value: body,
      Key.fieldId.value: fieldId,
      Key.entryId.value: entryId
      ])
  }

  /**
   Preparation.
   */
  public override class func create(schema: Schema.Creator) throws {
    schema.text(Key.body.snaked)
    schema.parent(Field.self, optional: false)
    schema.parent(Entry.self, optional: false)
  }
}

// MARK: - Helpers

extension Content {

  public static func new() throws -> Content {
    let node = try Node(node: [Key.body.value: ""])
    return try Content(node: node)
  }
}
