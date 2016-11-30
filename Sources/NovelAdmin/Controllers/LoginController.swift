import Vapor
import HTTP
import Turnstile

final class LoginController: Controller {

  // MARK: - Routes

  func index(request: Request) throws -> ResponseRepresentable {
    let context = ["title": drop.localization[request.lang, "login", "title"]]
    return try makeLogin(context: context, request: request)
  }

  func login(request: Request) throws -> ResponseRepresentable {
    guard let node = request.formURLEncoded else {
      throw Abort.badRequest
    }

    let response: ResponseRepresentable

    do {
      try request.auth.login(node)
      response = redirect(.admin)
    } catch let error as CustomStringConvertible {
      let context = ["flash": error.description]
      response = try makeLogin(context: context, request: request)
    } catch {
      let context = ["flash": "Invalid username or password"]
      response = try makeLogin(context: context, request: request)
    }

    return response
  }

  func logout(request: Request) throws -> ResponseRepresentable {
    try request.auth.logout()
    return redirect(.login)
  }

  // MARK: - Helpers

  fileprivate func makeLogin(context: Context, request: Request) throws -> ResponseRepresentable {
    return try drop.view.make(
      Template.Auth.login.path,
      makeContext(from: context, request: request)
    )
  }
}
