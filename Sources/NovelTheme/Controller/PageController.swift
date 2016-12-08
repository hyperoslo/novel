import Vapor
import HTTP
import NovelCore

final class PageController: Controller {

  func home(request: Request) throws -> ResponseRepresentable {
    return try drop.view.make("app/home")
  }
}
