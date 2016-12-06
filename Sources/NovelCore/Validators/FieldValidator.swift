import Vapor

public struct FieldValidator: NodeValidator {

  public let node: Node
  public var errors: [String: Node] = [:]

  public init(node: Node) {
    self.node = node

    validate(key: Field.Key.name.value, by: NameValidation.self)
    validate(key: Field.Key.handle.value, by: NameValidation.self)
    validate(key: Field.Key.kind.value, by: FieldValidation.self)
  }
}
