enum Route: String {
  case admin
  case login
  case logout
  case setup
  case signup
  case reset
  case users
  case entries
  case prototypes
  case settings

  var relative: String {
    return "/\(rawValue)"
  }

  var absolute: String {
    guard self != .admin else {
      return relative
    }

    return "/admin\(relative)"
  }

  func new(isRelative: Bool = false) -> String {
    let prefix = isRelative ? relative : absolute
    return "\(prefix)/new"
  }

  func show(id: Int, isRelative: Bool = false) -> String {
    let prefix = isRelative ? relative : absolute
    return "\(prefix)/\(id)"
  }
}
