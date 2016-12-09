struct Template {

  enum Auth: String {
    case login
    case setup
    case signup

    var path: String {
      return Template.path("auth/\(rawValue)")
    }
  }

  enum Main: String {
    case dashboard
    case entry
    case prototype
    case globals
    case user
    case settings

    func path(_ name: String = "") -> String {
      let suffix = name.isEmpty ? "" : "/\(name)"
      return Template.path("main/\(rawValue)\(suffix)")
    }

    var index: String {
      return path("index")
    }

    var new: String {
      return path("new")
    }

    var edit: String {
      return path("edit")
    }

    var show: String {
      return path("show")
    }
  }

  static func path(_ name: String) -> String {
    return "admin/\(name)"
  }
}
