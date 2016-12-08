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
        entries.get(String.self, handler: entryController.index)
        entries.get(String.self, Int.self, handler: entryController.show)
      }
    }
  }
}
