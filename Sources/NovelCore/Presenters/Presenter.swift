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

// MARK: - Chapter

public struct ChapterPresenter: Presenter {

  public typealias Key = Chapter.Key
  public let model: Chapter

  public init(model: Chapter) {
    self.model = model
  }

  public func makeNode() throws -> Node {
    var node = try Node(node: [
      Key.id.rawValue: model.id,
      Key.name.rawValue: model.name,
      Key.handle.rawValue: model.handle,
      Key.description.rawValue: model.description
      ])

    let fields = try model.fields().all()
    node["fields"] = try Node.array(fields.map({ try FieldPresenter(model: $0).makeNode() }))

    return node
  }
}

// MARK: - Entry

public struct EntryPresenter: Presenter {

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
      Key.createdAt.rawValue: Date(timeIntervalSince1970: TimeInterval(model.createdAt)).rfc1123,
      Key.updatedAt.rawValue: Date(timeIntervalSince1970: TimeInterval(model.createdAt)).rfc1123,
      Key.publishedAt.rawValue: Date(timeIntervalSince1970: TimeInterval(model.createdAt)).rfc1123,
      ])

    guard let chapter = try model.chapter().get() else {
      return node
    }

    node["chapter"] = try ChapterPresenter(model: chapter).makeNode()

    let fields = try chapter.fields().all()
    let contents = try model.contents().all()
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

// MARK: - Field

public struct FieldPresenter: Presenter {

  public typealias Key = Field.Key
  public let model: Field

  public init(model: Field) {
    self.model = model
  }

  public func makeNode() throws -> Node {
    let node = try Node(node: [
      Key.id.rawValue: model.id,
      Key.kind.rawValue: model.kind,
      Key.name.rawValue: model.name,
      Key.handle.rawValue: model.handle,
      Key.isRequired.rawValue: model.isRequired,
      Key.minLength.rawValue: model.minLength,
      Key.maxLength.rawValue: model.maxLength
      ])

    return node
  }
}

// MARK: - Content

public struct ContentPresenter: Presenter {

  public typealias Key = Content.Key
  public let model: Content

  public init(model: Content) {
    self.model = model
  }

  public func makeNode() throws -> Node {
    var node = try Node(node: [
      Key.id.rawValue: model.id,
      Key.body.rawValue: model.body
      ])

    if let field = try model.field().get() {
      node["field"] = try FieldPresenter(model: field).makeNode()
    }

    return node
  }
}
