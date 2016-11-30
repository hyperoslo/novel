import Vapor
import NovelCore

struct FieldValidator: NodeValidator {

  let node: Node
  var errors: [String: Node] = [:]

  init(node: Node) {
    self.node = node

    validate(key: Field.Key.name.value, by: NameValidation.self)
    validate(key: Field.Key.handle.value, by: NameValidation.self)
    validate(key: Field.Key.kind.value, by: FieldValidation.self)
  }
}
