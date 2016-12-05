import Vapor

public protocol Presenter {
  associatedtype T: Model

  var model: T { get }
  init(model: T)
  func makeNode() throws -> Node
  func makeJSON() throws -> JSON
}

extension Presenter {

  public func makeJSON() throws -> JSON {
    let node = try makeNode()
    return try JSON(node: node)
  }
}
