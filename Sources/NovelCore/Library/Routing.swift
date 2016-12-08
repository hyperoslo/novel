public protocol RouteRepresentable {

  static var root: String { get }
  var relative: String { get }
  var absolute: String { get }
  func new(isRelative: Bool) -> String
  func show(id: Int, isRelative: Bool) -> String
}

public extension RouteRepresentable where Self: RawRepresentable, Self.RawValue == String {

  var relative: String {
    return "/\(rawValue)"
  }

  var absolute: String {
    guard self.rawValue != Self.root else {
      return relative
    }

    return "\(Self.root)\(relative)"
  }
}

public extension RouteRepresentable {

  func new(isRelative: Bool = false) -> String {
    let prefix = isRelative ? relative : absolute
    return "\(prefix)/new"
  }

  func show(id: Int, isRelative: Bool = false) -> String {
    let prefix = isRelative ? relative : absolute
    return "\(prefix)/\(id)"
  }
}
