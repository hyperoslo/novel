import Vapor
import HTTP
import NovelCore

final class SettingsController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    let context = [
      "settings": try Setting.all().makeNode()
    ]

    return try drop.view.make(
      Template.Main.settings.index,
      makeContext(from: context, request: request)
    )
  }
}
