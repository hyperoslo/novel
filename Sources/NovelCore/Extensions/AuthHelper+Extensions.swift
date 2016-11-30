import Auth

public extension Helper {

  var isAuthenticated: Bool {
    return (try? user()) != nil
  }
}
