import Foundation
import Vapor
import Fluent

public class Model: Vapor.Model {

  public enum Required: String {
    case id
    case createdAt
    case updatedAt
  }

  public class var entityName: String {
    return name + "s"
  }

  public static var entity: String {
    return entityName
  }

  public var exists: Bool = false

  // Fields
  public var id: Node?
  public var createdAt: Date
  public var updatedAt: Date

  // Validation
  public var validator: NodeValidator.Type?

  /**
   Initializer.
   */
  public required init(node: Node, in context: Context) throws {
    id = node[Required.id.value]
    createdAt = node[Required.createdAt.value]?.string?.iso8601 ?? Date()
    updatedAt = node[Required.updatedAt.value]?.string?.iso8601 ?? Date()
  }

  public convenience init(node: Node) throws {
    try self.init(node: node, in: EmptyNode)
  }

  /**
   Fluent serialization.
   */
  public func makeNode(context: Context) throws -> Node {
    var node = try Node(node: [
      Required.id.value: id,
      Required.createdAt.value: createdAt.iso8601,
      Required.updatedAt.value: updatedAt.iso8601,
      ])

    node.merge(with: try makeNode())

    return node
  }

  public func makeNode() throws -> Node {
    return try Node(node: [])
  }

  // MARK: - Preparations

  public static func prepare(_ database: Database) throws {
    try database.create(entityName) { schema in
      schema.id(unique: true)
      schema.timestamp(Required.createdAt.value)
      schema.timestamp(Required.updatedAt.value)
      try self.create(schema: schema)
    }
  }

  public static func revert(_ database: Database) throws {
    try database.delete(entityName)
  }

  public class func create(schema: Schema.Creator) throws {
    fatalError("Must be implemented in subclass")
  }
}

// MARK: - Helpers

extension Model {

  public func validate() throws {
    guard let Validator = self.validator else {
      return
    }

    let node = try makeNode()
    let validator = Validator.init(node: node)

    if !validator.isValid {
      throw InputError(data: node, errors: validator.errors)
    }
  }

  public func updated(from node: Node, exists: Bool = false) throws -> Self {
    var updatedNode = try makeNode()
    updatedNode.merge(with: node)

    let model = try type(of: self).init(node: updatedNode, in: EmptyNode)
    model.exists = exists

    return model
  }
}

