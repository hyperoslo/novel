import Vapor
import Auth

struct MiddlewareConfigurator: Configurator {

  func configure(drop: Droplet) throws {
    drop.addConfigurable(middleware: AuthMiddleware<User>(), name: "auth")
  }
}
