import Vapor

public struct SettingValidator: NodeValidator {

  public let node: Node
  public var errors: [String: Node] = [:]

  public init(node: Node) {
    self.node = node

    validate(key: Setting.Key.name.value, by: NameValidation.self)
    validate(key: Setting.Key.handle.value, by: NameValidation.self)
  }
}
