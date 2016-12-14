import Vapor
import Fluent
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
    return "/admin"
  }
}

// MARK: - Functions

func createDroplet() -> Droplet {
  let drop = Droplet()
  drop.database = Database(MemoryDriver())
  return drop
}

func createUser() throws -> User {
  let node = try Node(node: [
    User.Key.username.value : "admin",
    User.Key.email.value : "test@example.org",
    User.Key.password.value: "secret",
    User.Key.firstname.value: "Super",
    User.Key.lastname.value: "Admin"
  ])

  return try User(node: node, in: EmptyNode)
}

