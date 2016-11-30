import Vapor

public struct NameValidation: ValidationSuite {

  public static func validate(input value: String) throws {
    let evaluation = OnlyAlphanumeric.self
      && Count.containedIn(low: 3, high: 50)

    try evaluation.validate(input: value)
  }
}

public struct FieldValidation: ValidationSuite {

  public static func validate(input value: Int) throws {
    let kinds = FieldKind.all().map { $0.rawValue }
    try In(kinds).validate(input: value)
  }
}

public struct PasswordValidation: Validator {

  fileprivate let confirmation: String

  public init(confirmation: String) {
    self.confirmation = confirmation
  }

  public func validate(input value: String) throws {
    let evaluation = Count<String>.containedIn(low: 7, high: 50)
    try evaluation.validate(input: value)

    if value != confirmation {
      throw error(with: value, message: "Passwords don't match")
    }
  }
}
