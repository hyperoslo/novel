import Vapor
import Fluent
import VaporPostgreSQL

struct DatabaseConfigurator: Configurator {

  func configure(drop: Droplet) throws {
    try drop.addProvider(VaporPostgreSQL.Provider.self)
    drop.preparations = [User.self, Entry.self, Chapter.self, Field.self, Content.self]
  }
}
