import Vapor
import HTTP
import NovelCore

final class PrototypeController: Controller {

  // All prototypes

  func index(request: Request) throws -> ResponseRepresentable {
    let context: Context = [
      "prototypes": try PrototypePresenter.makeNodes(from: try Prototype.all())
    ]

    return try drop.view.make("app/prototype/index", context)
  }
}
