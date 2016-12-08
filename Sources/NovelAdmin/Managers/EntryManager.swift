import Vapor
import NovelCore
import Foundation

final class EntryManager {

  var entry: Entry
  let date = Date()

  init(entry: Entry) {
    self.entry = entry
  }

  @discardableResult func create(from node: Node, prototype: Prototype) throws -> Entry {
    var node = node

    node[Entry.Key.createdAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()
    node[Entry.Key.updatedAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()
    node[Entry.Key.publishedAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()

    entry.set(prototype: prototype)
    try entry.validate()
    try entry.save()

    for (index, field) in try prototype.fields().all().enumerated() {
      let contentNode = fieldNode(from: node, index: index)
      var content = try Content(node: contentNode)
      try content.validate()
      content.set(entry: entry)
      content.set(field: field)
      try content.save()
    }

    return entry
  }

  @discardableResult func update(from node: Node) throws -> Entry {
    var node = node
    node[Entry.Key.updatedAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()

    entry = try entry.updated(from: node, exists: true)
    try entry.validate()
    try entry.save()

    for (index, content) in try entry.contents().all().enumerated() {
      let contentNode = fieldNode(from: node, index: index)
      var content = try content.updated(from: contentNode, exists: true)
      try content.validate()
      try content.save()
    }
    
    return entry
  }

  func fieldNode(from node: Node, index: Int) -> Node {
    var result: Node

    func transform(fieldNode: Node) -> Node {
      return Node.object(["body": fieldNode])
    }

    if let fieldNodes = node["fields"]?.nodeArray, index < fieldNodes.count {
      result = transform(fieldNode: fieldNodes[index])
    } else {
      result = transform(fieldNode: "")
    }

    return result
  }
}
