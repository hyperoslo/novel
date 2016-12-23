import Vapor
import HTTP
import NovelCore

final class PrototypeController: Controller {

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
    let prototype = try Prototype.new()

    let context: Context = [
      "prototype": try PrototypePresenter(model: prototype).makeNode()
    ]

    return try drop.view.make(
      Template.Main.prototype.new,
      makeContext(from: context, request: request)
    )
  }

  func store(request: Request) throws -> ResponseRepresentable {
    guard let node = request.formURLEncoded else {
      throw Abort.badRequest
    }

    let prototype = try Prototype.new()
    let manager = PrototypeManager(prototype: prototype)

    do {
      try manager.create(from: node)
    } catch let error as InputError {
      let context: Context = [
        "prototype": try PrototypePresenter(model: manager.prototype).makeNode(),
        "flash": "Please fill the required fields",
        "errors": Node.object(error.errors)
      ]

      return try drop.view.make(
        Template.Main.prototype.new,
        makeContext(from: context, request: request)
      )
    } catch {
      throw Abort.serverError
    }

    return redirect(Route.prototypes)
  }

  func show(request: Request, id: Int) throws -> ResponseRepresentable {
    guard let prototype = try Prototype.find(id) else {
      throw Abort.notFound
    }

    let context: Context = [
      "prototype": try PrototypePresenter(model: prototype).makeNode()
    ]

    return try drop.view.make(
      Template.Main.prototype.show,
      makeContext(from: context, request: request)
    )
  }

  func replace(request: Request, id: Int) throws -> ResponseRepresentable {
    guard let prototype = try Prototype.find(id) else {
      throw Abort.notFound
    }

    guard let node = request.formURLEncoded else {
      throw Abort.badRequest
    }

    let manager = PrototypeManager(prototype: prototype)

    do {
      try manager.update(from: node)
    } catch let error as InputError {
      let context = [
        "prototype": try PrototypePresenter(model: manager.prototype).makeNode(),
        "flash": "Please fill the required fields",
        "errors": Node.object(error.errors)
      ]

      return try drop.view.make(
        Template.Main.prototype.new,
        makeContext(from: context, request: request)
      )
    } catch {
      throw Abort.serverError
    }

    return redirect(Route.prototypes.show(id: id, isRelative: false))
  }
}
