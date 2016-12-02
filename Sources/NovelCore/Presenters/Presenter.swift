import Vapor

public protocol Presenter {
  associatedtype T: Model

  var model: T { get }
  init(model: T)
  func makeNode() throws -> Node
}
