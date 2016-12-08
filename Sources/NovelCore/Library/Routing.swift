public protocol RouteRepresentable {

  var relative: String { get }
  var absolute: String { get }
  func new(isRelative: Bool) -> String
  func show(id: Int, isRelative: Bool) -> String
}
