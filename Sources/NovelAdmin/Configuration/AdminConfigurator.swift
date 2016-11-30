import Vapor
import Leaf
import NovelCore

public struct AdminConfigurator: Configurator {

  public init() {}

  public func configure(drop: Droplet) {
    let configurators: [Configurator] = [
      RouteConfigurator(),
      LeafConfigurator()
    ]

    configurators.forEach { configurator in
      configurator.configure(drop: drop)
    }
  }
}
