import Vapor
import HTTP
import NovelCore

final class EntryController: Controller {

  // All entries

  func index(request: Request) throws -> ResponseRepresentable {
    let context: Context = [
      "entries": try EntryPresenter.makeNodes(from: try Entry.all())
    ]

    return try drop.view.make("app/entry/index", context)
  }

  // All entries by prototype handle

  func index(request: Request, handle: String) throws -> ResponseRepresentable {
    guard let prototype = try Prototype.find(handle: handle) else {
      throw Abort.notFound
    }

    let context = [
      "prototype": try PrototypePresenter(model: prototype).makeNode(),
      "entries": try EntryPresenter.makeNodes(from: try prototype.entries().all())
    ]

    return try drop.view.make("app/entry/index", context)
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

    return try drop.view.make("app/entry/show", context)
  }
}
