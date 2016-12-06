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
    case chapterId
  }

  public var exists: Bool = false

  // Fields
  public var id: Node?
  public var kind: Int
  public var name: String
  public var handle: String
  public var isRequired: Bool?
  public var minLength: Int?
  public var maxLength: Int?

  // Relations
  public var chapterId: Node?

  public func chapter() throws -> Parent<Chapter> {
    return try parent(chapterId)
  }

  public func set(chapter: Chapter) {
    chapterId = chapter.id
  }

  /**
   Fluent initializer.
   */
  public init(node: Node, in context: Context) throws {
    id = node[Key.id.value]
    kind = try node.extract(Key.kind.value)
    name = try node.extract(Key.name.value)
    handle = try node.extract(Key.handle.value)
    isRequired = try? node.extract(Key.isRequired.value)
    minLength = try? node.extract(Key.minLength.value)
    maxLength = try? node.extract(Key.maxLength.value)
    chapterId = node[Key.chapterId.value]
  }

  /**
   Fluent serialization.
   */
  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      Key.id.value: id,
      Key.kind.value: kind,
      Key.name.value: name,
      Key.handle.value: handle,
      Key.isRequired.value: isRequired,
      Key.minLength.value: minLength,
      Key.maxLength.value: maxLength,
      Key.chapterId.value: chapterId
      ])
  }
}

// MARK: - Preparations

extension Field {

  public static func prepare(_ database: Database) throws {
    try database.create(Field.entity) { users in
      users.id()
      users.int(Key.kind.value)
      users.string(Key.name.value, length: 50)
      users.string(Key.handle.value, length: 50)
      users.bool(Key.isRequired.value, optional: true)
      users.int(Key.minLength.value, optional: true)
      users.int(Key.maxLength.value, optional: true)
      users.parent(Chapter.self, optional: false)
    }
  }

  public static func revert(_ database: Database) throws {
    try database.delete(Field.entity)
  }
}

// MARK: - Validations

extension Field {

  public func validate() throws {
    let node = try makeNode()
    let validator = FieldValidator(node: node)

    if !validator.isValid {
      throw InputError(data: node, errors: validator.errors)
    }
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
