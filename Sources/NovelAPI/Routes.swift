import NovelCore

enum Route: String, RouteRepresentable  {
  case entries
  case prototypes
  case settings

  static var root: String {
    return "/api"
  }
}
