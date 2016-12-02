import Vapor
import Fluent
import VaporPostgreSQL
import VaporSQLite

struct DatabaseConfigurator: Configurator {

  func configure(drop: Droplet) throws {
    try drop.addProvider(VaporSQLite.Provider.self)
    drop.preparations = [User.self, Entry.self, Chapter.self, Field.self, Content.self]
  }
}
