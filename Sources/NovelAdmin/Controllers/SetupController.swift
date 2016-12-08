import Vapor
import Auth
import HTTP
import Turnstile
import NovelCore

final class SetupController: Controller {

  // MARK: - General

  func index(request: Request) throws -> ResponseRepresentable {
    let context: Context = [
      "title": drop.localization[request.lang, "login", "title"],
      "settings": try SettingsManager().all()
    ]

    return try makeSetup(context: context, request: request)
  }

  func setup(request: Request) throws -> ResponseRepresentable {
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
      response = redirect(Route.signup)
    } catch let error as InputError  {
      context["errors"] = Node.object(error.errors)
      response = try makeSetup(context: context, request: request)
    } catch {
      response = try makeSetup(context: context, request: request)
    }

    return response
  }

  // MARK: - Account

  func signup(request: Request) throws -> ResponseRepresentable {
    let context = [
      "title": drop.localization[request.lang, "login", "title"]
    ]

    return try makeSignup(context: context, request: request)
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
      response = redirect(Route.root)
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

  fileprivate func makeSetup(context: Context, request: Request) throws -> ResponseRepresentable {
    return try drop.view.make(
      Template.Auth.setup.path,
      makeContext(from: context, request: request)
    )
  }

  fileprivate func makeSignup(context: Context, request: Request) throws -> ResponseRepresentable {
    return try drop.view.make(
      Template.Auth.signup.path,
      makeContext(from: context, request: request)
    )
  }
}
