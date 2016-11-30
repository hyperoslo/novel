enum Route: String {
  case admin
  case login
  case logout
  case signup
  case reset

  var relative: String {
    return "/\(rawValue)"
  }

  var absolute: String {
    guard self != .admin else {
      return relative
    }

    return "/admin\(relative)"
  }
}

enum Template: String {
  case login
  case signup
  case dashboard
}
