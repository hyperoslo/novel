import Vapor

public struct SettingValidator: NodeValidator {

  public let node: Node
  public var errors: [String: Node] = [:]

  public init(node: Node) {
    self.node = node

    validate(key: Setting.Key.name.value, by: NameValidation.self)
    validate(key: Setting.Key.handle.value, by: NameValidation.self)
    validate(key: Setting.Key.value.value, by: Count<String>.min(1))
  }
}

public struct SetupValidator: NodeValidator {

  public let node: Node
  public var errors: [String: Node] = [:]

  public init(node: Node) {
    self.node = node

    validate(key: Setting.General.siteName.value, by: Count<String>.min(3))
    validate(key: Setting.General.siteUrl.value, by: Count<String>.min(5))
  }
}

