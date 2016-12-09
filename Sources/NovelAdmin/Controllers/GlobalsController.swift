import Vapor
import HTTP
import NovelCore
import Sessions
import Cookies

final class GlobalsController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    return try drop.view.make(Template.Main.globals.index)
  }
}
