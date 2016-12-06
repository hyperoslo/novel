import Vapor

public struct UserValidator: NodeValidator {

  typealias Key = User.Key

  public enum ChapterError: String, Error {
    case noFields = "Chapter may have al least 1 field."
  }

  public var node: Node
  public var errors: [String: Node] = [:]

  public init(node: Node) {
    self.node = node
    validate(key: Key.username.value, by: NameValidation.self)
    validate(key: Key.email.value, by: Email.self)

    if node[Key.firstname.value]?.string != nil {
      validate(key: Key.firstname.value, by: NameValidation.self)
    }

    if node[Key.lastname.value]?.string != nil {
      validate(key: Key.lastname.value, by: NameValidation.self)
    }

    let confirmation = node["\(Key.password.rawValue)_confirmation"]?.string ?? ""

    validate(key: Key.password.value, by: PasswordValidation(confirmation: confirmation))
  }
}
