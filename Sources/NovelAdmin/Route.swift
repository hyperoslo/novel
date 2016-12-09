import NovelCore

enum Route: String, RouteRepresentable  {
  case login
  case logout
  case setup
  case signup
  case reset
  case users
  case entries
  case prototypes
  case globals
  case settings

  static var root: String {
    return "/admin"
  }
}
