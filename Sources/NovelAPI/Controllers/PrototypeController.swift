import Vapor
import HTTP
import NovelCore

final class PrototypeController: Controller {

  // All prototypes

  func index(request: Request) throws -> ResponseRepresentable {
    let context: Context = [
      "prototypes": try PrototypePresenter.makeNodes(from: try Prototype.all())
    ]

    return try JSON(node: context)
  }

  // Single entry

  func show(request: Request, handle: String) throws -> ResponseRepresentable {
    guard let prototype = try Prototype.find(handle: handle) else {
      throw Abort.notFound
    }
    
    let context: Context = [
      "prototype": try PrototypePresenter(model: prototype).makeNode()
    ]

    return try JSON(node: context)
  }
}
