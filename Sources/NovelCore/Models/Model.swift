import Vapor
import Fluent

public protocol Model: Vapor.Model {
  func validate() throws
}

extension Model {

  public func updated(from node: Node, exists: Bool = false) throws -> Self {
    var updatedNode = try makeNode()
    updatedNode.merge(with: node)

    var model = try Self(node: updatedNode)
    model.exists = exists

    return model
  }
}
