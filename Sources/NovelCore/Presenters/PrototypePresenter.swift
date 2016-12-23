import Vapor
import Foundation

public struct PrototypePresenter: Presenter {

  public static func makeNodes(from models: [Prototype]) throws -> Node {
    let nodes = try models.map({ try PrototypePresenter(model: $0).makeNode() })
    return try nodes.makeNode()
  }

  public typealias Key = Prototype.Key
  public typealias Required = Prototype.Required

  public let model: Prototype

  public init(model: Prototype) {
    self.model = model
  }

  public func makeNode() throws -> Node {
    var node = try Node(node: [
      Required.id.rawValue: model.id,
      Key.name.rawValue: model.name,
      Key.handle.rawValue: model.handle,
      Key.description.rawValue: model.description
      ])

    guard model.id != nil else {
      return node
    }

    let fields = try model.fields().all()
    node["fields"] = try Node.array(fields.map({ try FieldPresenter(model: $0).makeNode() }))

    return node
  }
}
