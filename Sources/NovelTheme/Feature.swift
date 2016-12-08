import NovelCore

public struct Feature: NovelCore.Feature {

  public let configurators: [Configurator] = [
    RouteConfigurator()
  ]

  public init() {}
}
