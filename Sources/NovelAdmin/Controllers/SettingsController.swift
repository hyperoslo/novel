import Vapor
import HTTP
import NovelCore

final class SettingsController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    let context = [
      "settings": try SettingsPresenter().general()
    ]

    return try makeSettings(context: context, request: request)
  }

  func store(request: Request) throws -> ResponseRepresentable {
    guard let node = request.formURLEncoded else {
      throw Abort.badRequest
    }

    var context: Context = [
      "flash": "Please fill the required fields",
      "settings": node
    ]

    let response: ResponseRepresentable

    do {
      try SettingsManager().create(node: node)
      response = redirect(Route.settings)
    } catch let error as InputError  {
      context["errors"] = Node.object(error.errors)
      response = try makeSettings(context: context, request: request)
    } catch {
      response = try makeSettings(context: context, request: request)
    }

    return response
  }

  // MARK: - Helpers

  fileprivate func makeSettings(context: Context, request: Request) throws -> ResponseRepresentable {
    return try drop.view.make(
      Template.Main.settings.index,
      makeContext(from: context, request: request)
    )
  }
}
