import Vapor
import Fluent
import VaporPostgreSQL

struct DatabaseConfigurator: Configurator {

  func configure(drop: Droplet) throws {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
    drop.preparations = [
      Content.self,
      Entry.self,
      Field.self,
      Prototype.self,
      Session.self,
      Setting.self,
      User.self
    ]
  }
}
