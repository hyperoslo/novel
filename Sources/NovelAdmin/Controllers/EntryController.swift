import Vapor
import HTTP
import NovelCore

final class EntryController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    return try drop.view.make(
      Template.Main.entry.index,
      makeContext(request: request)
    )
  }
}
