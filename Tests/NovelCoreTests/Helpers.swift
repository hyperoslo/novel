import Vapor
@testable import NovelCore

final class TestConfigurator: Configurator {

  var isConfigured = false

  func configure(drop: Droplet) throws {
    isConfigured = true
  }
}

final class TestFeature: Feature {

  let configurators: [Configurator] = [
    TestConfigurator()
  ]
}

final class TestController: Controller {}

import NovelCore

enum TestRoute: String, RouteRepresentable  {
  case users

  static var root: String {
    return "/"
  }
}


func createDroplet() -> Droplet {
  let drop = Droplet()
  return drop
}

