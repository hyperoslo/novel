import Vapor
@testable import NovelCore

final class TestConfigurator: Configurator {

  var isConfigured = false

  func configure(drop: Droplet) throws {
    isConfigured = true
  }
}
