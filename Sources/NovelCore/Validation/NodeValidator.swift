import Vapor
import Foundation

public protocol NodeValidator {
  var node: Node { get }
  var errors: [String: Node] { get set }
  init(node: Node)
}

public struct InputError: Error {

  public let data: Node
  public let errors: [String: Node]

  public init(data: Node, errors: [String: Node]) {
    self.data = data
    self.errors = errors
  }
}

enum NodeValidorError: String, Error {
  case missingField = "Field is missing"
}

public extension NodeValidator {

  var isValid: Bool {
    return errors.isEmpty
  }

  mutating func validate<T: ValidationSuite>(key: String, by suite: T.Type)
    where T.InputType: PolymorphicInitializable {
      validate(key: key) { value in
        _ = try value.validated(by: suite)
      }
  }

  mutating func validate<T: Validator>(key: String, by validator: T)
    where T.InputType: PolymorphicInitializable {
      validate(key: key) { value in
        _ = try value.validated(by: validator)
      }
  }

  fileprivate mutating func validate(key: String, by validation: (Node) throws -> Void) {
    do {
      guard let value = node[key] else {
        errors[key] = Node.string(NodeValidorError.missingField.rawValue)
        return
      }
      _ = try validation(value)
    } catch let error as ValidationErrorProtocol {
      errors[key] = Node.string(error.message)
    } catch {
      errors[key] = Node.string(error.localizedDescription)
    }
  }
}
