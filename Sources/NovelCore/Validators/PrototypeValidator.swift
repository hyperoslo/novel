import Vapor
import Jay

public struct PrototypeValidator: NodeValidator {

  enum PrototypeError: String, Error {
    case noFields = "Prototype may have al least 1 field."
  }

  public var node: Node
  public var errors: [String: Node] = [:]

  public init(node: Node) {
    self.node = node
    validate(key: Prototype.Key.name.value, by: NameValidation.self)
    validate(key: Prototype.Key.handle.value, by: NameValidation.self)
  }
}
