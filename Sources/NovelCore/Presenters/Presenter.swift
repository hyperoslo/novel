import Vapor
import Foundation

public protocol Presenter {
  associatedtype T: Model

  var model: T { get }
  func makeNode() throws -> Node
  func makeJSON() throws -> JSON
}

extension Presenter {

  public func makeJSON() throws -> JSON {
    let node = try makeNode()
    return try JSON(node: node)
  }
}
