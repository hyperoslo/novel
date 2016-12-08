import Vapor
import HTTP
import NovelCore

final class PrototypeController: Controller {

  func buildContext() throws -> Context {
    return [
      "kinds": try FieldKind.all().makeNode()
    ]
  }

  func index(request: Request) throws -> ResponseRepresentable {
    let context = [
      "prototypes": try Prototype.all().makeNode()
    ]

    return try drop.view.make(
      Template.Main.prototype.index,
      makeContext(from: context, request: request)
    )
  }

  func new(request: Request) throws -> ResponseRepresentable {
    let context = try buildContext()

    return try drop.view.make(
      Template.Main.prototype.new,
      makeContext(from: context, request: request)
    )
  }

  func store(request: Request) throws -> ResponseRepresentable {
    guard let node = request.formURLEncoded else {
      throw Abort.badRequest
    }

    do {
      try PrototypeManager().create(node: node)
    } catch let error as InputError {
      var context = try buildContext()

      context["flash"] = "Please fill the required fields"
      context["errors"] = Node.object(error.errors)
      context["data"] = error.data

      return try drop.view.make(
        Template.Main.prototype.new,
        makeContext(from: context, request: request)
      )
    } catch {
      throw Abort.serverError
    }

    return redirect(.prototypes)
  }

  func show(request: Request, prototype: Prototype) -> ResponseRepresentable {
    return prototype
  }

  func replace(request: Request, prototype: Prototype) throws -> ResponseRepresentable {
    let context = [
      "prototype": try prototype.makeNode()
    ]

    return try drop.view.make(
      Template.Main.prototype.edit,
      makeContext(from: context, request: request)
    )
  }
}

extension PrototypeController: ResourceRepresentable {

  func makeResource() -> Resource<Prototype> {
    return Resource(
      index: index,
      store: store,
      show: show,
      replace: replace
    )
  }
}
