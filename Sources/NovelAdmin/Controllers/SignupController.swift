import Vapor
import Auth
import HTTP
import Turnstile
import NovelCore

final class SignupController: Controller {

  // MARK: - Routes

  func index(request: Request) throws -> ResponseRepresentable {
    let context = [
      "title": drop.localization[request.lang, "login", "title"]
    ]

    return try drop.view.make(
      Template.Auth.signup.path,
      makeContext(from: context, request: request)
    )
  }

  func register(request: Request) throws -> ResponseRepresentable {
    guard let node = request.formURLEncoded else {
      throw Abort.badRequest
    }

    var context: Context = [
      "flash": "Please fill the required fields",
      "data": node
    ]

    let response: ResponseRepresentable

    do {
      try UserManager().create(node: node)
      try request.auth.login(node)
      response = redirect(.admin)
    } catch let error as InputError  {
      context["errors"] = Node.object(error.errors)
      response = try makeSignup(context: context, request: request)
    } catch let error as CustomStringConvertible {
      context["flash"] = error.description
      response = try makeSignup(context: context, request: request)
    } catch {
      response = try makeSignup(context: context, request: request)
    }

    return response
  }

  // MARK: - Helpers

  fileprivate func makeSignup(context: Context, request: Request) throws -> ResponseRepresentable {
    return try drop.view.make(
      Template.Auth.signup.path,
      makeContext(from: context, request: request)
    )
  }
}
