import Vapor
import HTTP
import NovelCore

struct RouteConfigurator: Configurator {

  // MARK: - Configuration

  func configure(drop: Droplet) throws {
    drop.group(Route.root) { root in
      // Home
      let controller = PageController(drop: drop)
      root.get(handler: controller.home)

      // Entries
      root.group(Route.entries.relative) { entries in
        let controller = EntryController(drop: drop)

        entries.get(handler: controller.index)
        entries.get(String.self, handler: controller.index)
        entries.get(String.self, Int.self, handler: controller.show)
      }

      // Prototypes
      root.group(Route.prototypes.relative) { entries in
        let controller = PrototypeController(drop: drop)

        entries.get(handler: controller.index)
        entries.get(String.self, handler: controller.show)
      }
    }
  }
}
