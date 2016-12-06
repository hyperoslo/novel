import Vapor
import NovelCore
import Foundation

struct EntryManager {

  let date = Date()

  @discardableResult func create(chapter: Chapter, node: Node) throws -> Entry {
    var node = node

    node[Entry.Key.createdAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()
    node[Entry.Key.updatedAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()
    node[Entry.Key.publishedAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()

    var entry = try Entry(node: node)
    try entry.validate()
    entry.set(chapter: chapter)
    try entry.save()

    for (index, field) in try chapter.fields().all().enumerated() {
      let contentNode = fieldNode(from: node, index: index)
      var content = try Content(node: contentNode)
      try content.validate()
      content.set(entry: entry)
      content.set(field: field)
      try content.save()
    }

    return entry
  }

  @discardableResult func update(entry: Entry, node: Node) throws -> Entry {
    var node = node
    node[Entry.Key.updatedAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()

    var entry = try entry.updated(from: node)
    try entry.save()

    for (index, content) in try entry.contents().all().enumerated() {
      let updatedNode = fieldNode(from: node, index: index)
      var contentNode = try content.makeNode()
      contentNode.merge(with: updatedNode)
      var content = try Content(node: contentNode)
      try content.validate()
      try content.save()
    }
    
    return entry
  }

  func fieldNode(from node: Node, index: Int) -> Node {
    var result: Node

    func transform(fieldNode: Node) -> Node {
      return Node.object(["body": node])
    }

    if let fieldNodes = node["fields"]?.nodeArray, index < fieldNodes.count {
      result = transform(fieldNode: fieldNodes[index])
    } else {
      result = transform(fieldNode: "")
    }

    return result
  }
}
