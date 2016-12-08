import Vapor
import HTTP
import NovelCore

final class SettingsController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    let context = [
      "settings": try SettingsPresenter().general()
    ]

    return try JSON(node: context)
  }
}
