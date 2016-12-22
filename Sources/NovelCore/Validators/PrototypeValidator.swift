import Vapor
import Jay

public struct PrototypeValidator: NodeValidator {

  enum PrototypeError: String, Error {
    case noFields = "Prototype may have al least 1 field."
  }

  public var node: Node
  public var errors: [String: Node] = [:]
  public var fieldNodes: [Node] = []

  public init(node: Node) {
    self.node = node
    validate(key: Prototype.Key.name.value, by: NameValidation.self)
    validate(key: Prototype.Key.handle.value, by: NameValidation.self)
    validateFields()
  }

  fileprivate mutating func validateFields() {
    guard
      let bytes = node["fields"]?.string?.bytes,
      let json = try? Jay().jsonFromData(bytes),
      let data = try? Jay(formatting: .prettified).dataFromJson(json: json),
      let arrayOpt = try? JSON.init(bytes: data).makeNode().nodeArray,
      let array = arrayOpt
      else {
        errors["fields"] = Node.string(PrototypeError.noFields.rawValue)
        return
    }

    var fieldErrors = [Node]()
    fieldNodes = []

    for (i, item)  in array.enumerated() {
      var node: Node = [
        "index": Node(i),
        "name": Node.string(item["name"]?.string ?? ""),
        "handle": Node.string(item["handle"]?.string ?? ""),
        "kind": Node.string(item["kind"]?.string ?? ""),
      ]

      if let id = item["id"] {
        node["id"] = id
      }

      fieldNodes.append(node)

      let validator = FieldValidator(node: node)

      if !validator.isValid {
        fieldErrors.append(Node.object(validator.errors))
      }
    }

    node["fields"] = Node.array(fieldNodes)

    if !fieldErrors.isEmpty {
      errors["fields"] = Node.array(fieldErrors)
    }
  }
}
