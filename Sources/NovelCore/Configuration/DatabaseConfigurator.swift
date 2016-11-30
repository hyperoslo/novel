import Vapor
import Fluent

struct DatabaseConfigurator: Configurator {

  func configure(drop: Droplet) {
    drop.database = Database(MemoryDriver())
    drop.preparations = [User.self, Entry.self, Chapter.self, Field.self, Content.self]
  }
}
