import Vapor
import Foundation

public struct ContentPresenter: Presenter {

  public typealias Key = Content.Key
  public typealias Required = Content.Required

  public let model: Content

  public init(model: Content) {
    self.model = model
  }

  public func makeNode() throws -> Node {
    var node = try Node(node: [
      Required.id.rawValue: model.id,
      Key.body.rawValue: model.body
      ])

    if let field = try model.field().get() {
      node["field"] = try FieldPresenter(model: field).makeNode()
    } else {
      node["field"] = nil
    }

    return node
  }
}
