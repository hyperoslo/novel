import Vapor
import NovelCore

struct EntryValidator: NodeValidator {

  enum EntryError: String, Error {
    case noFields = "Entry fields are missing."
  }

  var node: Node
  var errors: [String: Node] = [:]
  var contentNodes: [Node] = []

  init(node: Node) {
    self.node = node
    validate(key: Entry.Key.title.value, by: Count<String>.containedIn(low: 1, high: 100))
    validateFields()
  }

  fileprivate mutating func validateFields() {
    guard let fields = node["fields"]?.nodeArray, !fields.isEmpty else {
      return
    }

    contentNodes = fields

    var fieldErrors = [Node]()

    for field in fields {
      let validator = ContentValidator(node: field)

      if !validator.isValid {
        fieldErrors.append(Node.object(validator.errors))
      }
    }

    if !fieldErrors.isEmpty {
      errors["fields"] = Node.array(fieldErrors)
    }
  }
}
