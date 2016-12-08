import Vapor
import HTTP
import NovelCore

final class PrototypeController: Controller, PrototypeResponder {

  // All prototypes

  func index(request: Request) throws -> ResponseRepresentable {
    let context: Context = [
      "prototypes": try PrototypePresenter.makeNodes(from: try Prototype.all())
    ]

    return try JSON(node: context)
  }

  // Single entry

  func show(request: Request, handle: String) throws -> ResponseRepresentable {
    let prototype = try findPrototype(by: handle)

    let context: Context = [
      "entry": try PrototypePresenter(model: prototype).makeNode()
    ]

    return try JSON(node: context)
  }
}
