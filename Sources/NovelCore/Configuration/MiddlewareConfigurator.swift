import Vapor
import Auth

struct MiddlewareConfigurator: Configurator {

  func configure(drop: Droplet) {
    drop.addConfigurable(middleware: AuthMiddleware<User>(), name: "auth")
  }
}
