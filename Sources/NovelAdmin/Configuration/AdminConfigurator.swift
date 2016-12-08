import Vapor
import Leaf
import NovelCore

public struct AdminConfigurator: Configurator {

  public init() {}

  public func configure(drop: Droplet) throws {
    let configurators: [Configurator] = [
      RouteConfigurator(),
      LeafConfigurator(),
      SettingsConfigurator()
    ]

    for configurator in configurators {
      try configurator.configure(drop: drop)
    }
  }
}
