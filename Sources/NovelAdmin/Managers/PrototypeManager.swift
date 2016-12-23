import Foundation
import Vapor
import NovelCore

final class PrototypeManager {

  var prototype: Prototype

  init(prototype: Prototype) {
    self.prototype = prototype
  }
  
  @discardableResult func create(from node: Node) throws -> Prototype {
    let node = node
    prototype = try prototype.updated(from: node)
    try prototype.validate()
    try prototype.save()
    return prototype
  }

  @discardableResult func update(from node: Node) throws -> Prototype {
    var node = node
    node[Entry.Required.updatedAt.snaked] = Date().iso8601.makeNode()

    prototype = try prototype.updated(from: node, exists: true)
    try prototype.validate()
    try prototype.save()

    return prototype
  }
}
