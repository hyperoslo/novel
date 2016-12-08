import Vapor
import HTTP

open class Controller {
  public let drop: Droplet

  public init(drop: Droplet) {
    self.drop = drop
  }
}

// MARK: - Helpers

public extension Controller {

  public typealias Context = [String: NodeRepresentable]

  public func redirect(_ route: RouteRepresentable) -> ResponseRepresentable {
    return Response(redirect: route.absolute)
  }

  public func redirect(_ route: String) -> ResponseRepresentable {
    return Response(redirect: route)
  }

  public func redirect(_ route: RouteRepresentable, id: Node?) -> ResponseRepresentable {
    guard let id = id?.int else {
      return redirect(route)
    }

    return Response(redirect: route.show(id: id, isRelative: false))
  }
}
