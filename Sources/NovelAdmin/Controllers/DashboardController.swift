import Vapor
import HTTP
import NovelCore
import Sessions
import Cookies

final class DashboardController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    return try drop.view.make(Template.Main.dashboard.path())
  }
}
