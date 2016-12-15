import Vapor
import HTTP
import NovelCore

final class EntryController: Controller {

  // All entries

  func index(request: Request) throws -> ResponseRepresentable {
    let context: Context = [
      "entries": try EntryPresenter.makeNodes(from: try Entry.all())
    ]

    return try JSON(node: context)
  }

  // All entries by prototype handle

  func index(request: Request, handle: String) throws -> ResponseRepresentable {
    guard let prototype = try Prototype.find(handle: handle) else {
      throw Abort.notFound
    }

    let context = [
      "entries": try EntryPresenter.makeNodes(from: try prototype.entries().all())
    ]

    return try JSON(node: context)
  }

  // Single entry

  func show(request: Request, handle: String, id: Int) throws -> ResponseRepresentable {
    guard
      let prototype = try Prototype.find(handle: handle),
      let entry = try prototype.entries().filter(Entry.Required.id.value, id).first()
      else {
        throw Abort.notFound
    }

    let context: Context = [
      "entry": try EntryPresenter(model: entry).makeNode()
    ]

    return try JSON(node: context)
  }
}
