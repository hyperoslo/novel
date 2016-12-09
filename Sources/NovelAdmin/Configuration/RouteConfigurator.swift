import Vapor
import HTTP
import NovelCore

struct RouteConfigurator: Configurator {

  let statusMiddleware = FallbackMiddleware(fallback: Route.setup.absolute) { request in
    return SetupMonitor.isCompleted
  }

  let setupMiddleware = FallbackMiddleware(fallback: Route.root) { request in
    return !SetupMonitor.isCompleted
  }

  let authMiddleware = FallbackMiddleware(fallback: Route.root) { request in
    return !request.auth.isAuthenticated
  }

  let adminMiddleware = FallbackMiddleware(fallback: Route.login.absolute) { request in
    return request.auth.isAuthenticated
  }

  // MARK: - Configuration

  func configure(drop: Droplet) throws {
    let loginController = LoginController(drop: drop)

    // Setup
    drop.grouped(setupMiddleware).group(Route.root) { admin in
      // Signup
      let setupController = SetupController(drop: drop)
      admin.get(Route.setup.relative, handler: setupController.index)
      admin.post(Route.setup.relative, handler: setupController.setup)
      admin.get(Route.signup.relative, handler: setupController.signup)
      admin.post(Route.signup.relative, handler: setupController.register)
    }

    // Auth
    drop.grouped(statusMiddleware, authMiddleware).group(Route.root) { admin in
      // Login
      admin.get(Route.login.relative, handler: loginController.index)
      admin.post(Route.login.relative, handler: loginController.login)
    }

    // Main
    drop.grouped(statusMiddleware, adminMiddleware).group(Route.root) { admin in
      // Logout
      admin.get(Route.logout.relative, handler: loginController.logout)

      // Index
      let dashboardController = DashboardController(drop: drop)
      admin.get(handler: dashboardController.index)

      // Prototypes
      let prototypeController = PrototypeController(drop: drop)
      admin.resource(Route.prototypes.relative, prototypeController)
      admin.get(Route.prototypes.new(isRelative: true), handler: prototypeController.new)

      // Entries
      admin.group(Route.entries.relative) { entries in
        let entryController = EntryController(drop: drop)

        entries.get(handler: entryController.index)
        entries.get(String.self, handler: entryController.index)
        entries.get(String.self, "new", handler: entryController.new)
        entries.get(String.self, Int.self, handler: entryController.show)
        entries.post(String.self, handler: entryController.store)
        entries.post(String.self, Int.self, handler: entryController.replace)
      }

      // Globals
      let globalsController = GlobalsController(drop: drop)
      admin.get(Route.globals.relative, handler: globalsController.index)

      // Users
      let userController = UserController(drop: drop)
      admin.resource(Route.users.relative, userController)

      // Settings
      let settingsController = SettingsController(drop: drop)
      admin.get(Route.settings.relative, handler: settingsController.index)
      admin.post(Route.settings.relative, handler: settingsController.store)
    }
  }
}
