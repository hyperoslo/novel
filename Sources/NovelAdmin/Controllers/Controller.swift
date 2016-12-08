import Vapor
import HTTP
import NovelCore

extension Controller {

  func makeContext(from context: Context = [:], request: Request) throws -> Context {
    var context = context

    if let user = try? request.user() {
      context["isAuthenticated"] = true
      context["account"] = try user.makeNode()
    } else {
      context["isAuthenticated"] = false
    }

    context["currentPath"] = request.uri.path

    return context
  }
}
