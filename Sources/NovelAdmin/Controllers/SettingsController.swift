import Vapor
import HTTP
import NovelCore

final class SettingsController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    return try drop.view.make(
      Template.Main.settings.path(),
      makeContext(request: request)
    )
  }
}
