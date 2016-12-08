import Vapor
import NovelCore

protocol PrototypeResponder {}

extension PrototypeResponder {

  func findPrototype(by handle: String) throws -> Prototype {
    guard let prototype = try Prototype.query().filter(Prototype.Key.handle.value, handle).first() else {
      throw Abort.notFound
    }

    return prototype
  }
}
