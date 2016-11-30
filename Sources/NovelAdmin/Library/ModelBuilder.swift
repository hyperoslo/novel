import Vapor
import NovelCore

struct ModelBuilder<T: Model> {
  let validator: NodeValidator

  func build() throws -> T {
    guard validator.isValid else {
      let data = validator.node
      throw InputError(data: data, errors: validator.errors)
    }

    return try T(node: validator.node)
  }
}

struct InputError: Error {

  let data: Node
  let errors: [String: Node]
}
