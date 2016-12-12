import Vapor
@testable import NovelCore

final class TestFeature: Feature {

  let configurators: [Configurator] = [
    TestConfigurator()
  ]
}
