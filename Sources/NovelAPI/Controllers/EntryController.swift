import Vapor
import HTTP
import NovelCore

final class EntryController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    let context: Context = [
      "entries": try EntryPresenter.makeNodes(from: try Entry.all())
    ]

    return try JSON(node: context)
  }

  func index(request: Request, prototype: Prototype) throws -> ResponseRepresentable {
    let context = [
      "prototypes": try Prototype.all().makeNode(),
      "entries": try EntryPresenter.makeNodes(from: try prototype.entries().all())
    ]

    return try JSON(node: context)
  }

  func show(request: Request, prototype: Prototype, entry: Entry) throws -> ResponseRepresentable {
    let context: Context = [
      "entry": try EntryPresenter(model: entry).makeNode()
    ]

    return try JSON(node: context)
  }
}
