import Vapor
import HTTP

class Controller {
  var drop: Droplet

  init(drop: Droplet) {
    self.drop = drop
  }
}

extension Controller {

  typealias Context = [String: NodeRepresentable]

  func redirect(_ route: Route) -> ResponseRepresentable {
    return Response(redirect: route.absolute)
  }

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
