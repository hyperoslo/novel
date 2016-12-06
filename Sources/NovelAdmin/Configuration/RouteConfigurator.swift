import Vapor
import HTTP
import NovelCore

struct RouteConfigurator: Configurator {

  let statusMiddleware = FallbackMiddleware(fallback: Route.signup.absolute) { request in
    return SetupMonitor.isCompleted
  }

  let setupMiddleware = FallbackMiddleware(fallback: Route.admin.absolute) { request in
    return !SetupMonitor.isCompleted
  }

  let authMiddleware = FallbackMiddleware(fallback: Route.admin.absolute) { request in
    return !request.auth.isAuthenticated
  }

  let adminMiddleware = FallbackMiddleware(fallback: Route.login.absolute) { request in
    return request.auth.isAuthenticated
  }

  // MARK: - Configuration

  func configure(drop: Droplet) throws {
    let loginController = LoginController(drop: drop)

    // Setup
    drop.grouped(setupMiddleware).group(Route.admin.absolute) { admin in
      // Signup
      let signupController = SignupController(drop: drop)
      admin.get(Route.signup.relative, handler: signupController.index)
      admin.post(Route.signup.relative, handler: signupController.register)
    }

    // Auth
    drop.grouped(statusMiddleware, authMiddleware).group(Route.admin.absolute) { admin in
      // Login
      admin.get(Route.login.relative, handler: loginController.index)
      admin.post(Route.login.relative, handler: loginController.login)
    }

    // Main
    drop.grouped(statusMiddleware, adminMiddleware).group(Route.admin.absolute) { admin in
      // Logout
      admin.get(Route.logout.relative, handler: loginController.logout)

      // Index
      let dashboardController = DashboardController(drop: drop)
      admin.get(handler: dashboardController.index)

      // Chapters
      let chapterController = ChapterController(drop: drop)
      admin.resource(Route.chapters.relative, chapterController)
      admin.get(Route.chapters.new(isRelative: true), handler: chapterController.new)

      // Entries

      admin.group(Route.entries.relative) { entries in
        let entryController = EntryController(drop: drop)

        entries.get(handler: entryController.index)
        entries.get(Chapter.self, handler: entryController.index)
        entries.get(Chapter.self, Route.entries.new(isRelative: true), handler: entryController.new)
        entries.get(Chapter.self, Entry.self, handler: entryController.show)
        entries.post(Chapter.self, handler: entryController.store)
        entries.post(Chapter.self, Entry.self, handler: entryController.replace)
      }

      // Users
      let userController = UserController(drop: drop)
      admin.resource(Route.users.relative, userController)

      // Settings
      let settingsController = SettingsController(drop: drop)
      admin.get(Route.settings.relative, handler: settingsController.index)
    }
  }
}
