import Vapor
import NovelCore

struct UserManager {

  @discardableResult func create(node: Node) throws -> User {
    let validator = UserValidator(node: node)

    guard validator.isValid else {
      let data = validator.node
      throw InputError(data: data, errors: validator.errors)
    }

    return try User.register(credentials: node) as! User
  }
}
