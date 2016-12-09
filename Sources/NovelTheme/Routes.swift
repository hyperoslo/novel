import NovelCore

enum Route: String, RouteRepresentable  {
  case entries
  case prototypes

  static var root: String {
    return "/"
  }
}
