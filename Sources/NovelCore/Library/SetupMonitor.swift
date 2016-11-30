public struct SetupMonitor {

  fileprivate static var hasUser: Bool {
    guard let isEmpty = try? User.all().isEmpty else {
      return false
    }

    return !isEmpty
  }

  public static var isCompleted: Bool {
    return hasUser
  }
}
