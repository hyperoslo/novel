import Vapor
import HTTP
import NovelCore

final class EntryController: Controller, PrototypeResponder {

  // All entries

  func index(request: Request) throws -> ResponseRepresentable {
    let context: Context = [
      "entries": try EntryPresenter.makeNodes(from: try Entry.all())
    ]

    return try JSON(node: context)
  }

  // All entries by prototype handle

  func index(request: Request, handle: String) throws -> ResponseRepresentable {
    let prototype = try findPrototype(by: handle)

    let context = [
      "entries": try EntryPresenter.makeNodes(from: try prototype.entries().all())
    ]

    return try JSON(node: context)
  }

  // Single entry

  func show(request: Request, handle: String, id: Int) throws -> ResponseRepresentable {
    let prototype = try findPrototype(by: handle)

    guard let entry = try prototype.entries().filter(Entry.Key.id.value, id).first() else {
      throw Abort.notFound
    }

    let context: Context = [
      "entry": try EntryPresenter(model: entry).makeNode()
    ]

    return try JSON(node: context)
  }
}
