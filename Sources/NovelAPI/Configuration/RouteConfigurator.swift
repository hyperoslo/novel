import Vapor
import HTTP
import NovelCore

struct RouteConfigurator: Configurator {

  // MARK: - Configuration

  func configure(drop: Droplet) throws {
    drop.group(Route.root) { root in
      // Entries
      root.group(Route.entries.relative) { entries in
        let entryController = EntryController(drop: drop)

        entries.get(handler: entryController.index)
        entries.get(Prototype.self, handler: entryController.index)
        entries.get(Prototype.self, Entry.self, handler: entryController.show)
      }
    }
  }
}
