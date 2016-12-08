import Vapor
import Foundation

public struct EntryPresenter: Presenter {

  public static func makeNodes(from models: [Entry]) throws -> Node {
    let nodes = try models.map({ try EntryPresenter(model: $0).makeNode() })
    return try nodes.makeNode()
  }

  public typealias Key = Entry.Key
  public let model: Entry
  public let data: Node?

  public init(model: Entry, data: Node? = nil) {
    self.model = model
    self.data = data
  }

  public func makeNode() throws -> Node {
    var node = try Node(node: [
      Key.id.rawValue: model.id,
      Key.title.rawValue : model.title,
      Key.createdAt.rawValue: model.createdAt.iso8601,
      Key.updatedAt.rawValue: model.updatedAt.iso8601,
      Key.publishedAt.rawValue: model.publishedAt.iso8601,
      ])

    guard let prototype = try model.prototype().get() else {
      return node
    }

    node["prototype"] = try PrototypePresenter(model: prototype).makeNode()

    let fields = try prototype.fields().all()
    let contents: [Content] = model.id == nil ? [] : try model.contents().all()
    var fieldNodes = [Node]()

    for (index, field) in fields.enumerated() {
      var fieldNode = try FieldPresenter(model: field).makeNode()

      if let content = contents.first(where: { $0.fieldId == field.id }) {
        fieldNode["body"] = content.body.makeNode()
      } else {
        fieldNode["body"] = ""
      }

      if let items = data?["fields"]?.nodeArray, index < items.count, let value = items[index].string {
        fieldNode["body"] = value.makeNode()
      }

      fieldNodes.append(fieldNode)
    }

    node["fields"] = try fieldNodes.makeNode()
    
    return node
  }
}
