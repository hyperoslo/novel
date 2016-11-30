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

  public func start() {
    let allConfigurators = coreConfigurators + configurators

    allConfigurators.forEach { configurator in
      configurator.configure(drop: drop)
    }

    drop.run()
  }
}
