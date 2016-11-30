import Vapor
import Leaf

public final class Application {

  let drop: Droplet

  let coreConfigurators: [Configurator] = [
    DatabaseConfigurator(),
    MiddlewareConfigurator()
  ]

  public var configurators: [Configurator] = []

  public init() {
    drop = Droplet()
  }

  public func start() throws {
    let allConfigurators = coreConfigurators + configurators

    for configurator in allConfigurators {
      try configurator.configure(drop: drop)
    }

    drop.run()
  }
}
