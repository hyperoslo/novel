import Vapor
import NovelCore
import Foundation

struct EntryManager {

  @discardableResult func create(chapter: Chapter, node: Node) throws -> Entry {
    var node = node
    let date = Date()

    node[Entry.Key.createdAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()
    node[Entry.Key.updatedAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()
    node[Entry.Key.publishedAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()

    let entryValidator = EntryValidator(node: node)
    var entry = try ModelBuilder<Entry>(validator: entryValidator).build()
    entry.set(chapter: chapter)

    try entry.save()

    for (index, field) in try chapter.fields().all().enumerated() {
      var contentNode: Node

      if index < entryValidator.contentNodes.count {
        contentNode = entryValidator.contentNodes[index]
      } else {
        contentNode = ContentValidator.transform(node: "")
      }

      let contentValidator = ContentValidator(node: contentNode)
      var content = try ModelBuilder<NovelCore.Content>(validator: contentValidator).build()
      content.set(entry: entry)
      content.set(field: field)

      try content.save()
    }

    return entry
  }

  @discardableResult func update(entry: Entry, node: Node) throws -> Entry {
    let updateNode = node
    var node = try entry.makeNode()
    node.merge(with: updateNode)
    let date = Date()

    node[Entry.Key.updatedAt.snaked] = try Int(date.timeIntervalSince1970).makeNode()

    let entryValidator = EntryValidator(node: node)
    var entry = try ModelBuilder<Entry>(validator: entryValidator).build()

    try entry.save()

    for (index, content) in try entry.contents().all().enumerated() {
      var contentNode = try content.makeNode()
      var updateNode: Node

      if index < entryValidator.contentNodes.count {
        updateNode = entryValidator.contentNodes[index]
      } else {
        updateNode = ContentValidator.transform(node: "")
      }

      contentNode.merge(with: updateNode)

      let contentValidator = ContentValidator(node: contentNode)
      var content = try ModelBuilder<NovelCore.Content>(validator: contentValidator).build()

      try content.save()
    }
    
    return entry
  }
}
