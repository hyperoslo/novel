import Vapor
import Auth

struct MiddlewareConfigurator: Configurator {

  func configure(drop: Droplet) throws {
    let cache = SessionCache()
    let authMiddleware = AuthMiddleware(user: User.self, cache: cache)

    drop.addConfigurable(middleware: authMiddleware, name: "auth")
  }
}
