import Vapor
import HTTP
import NovelCore

final class ChapterController: Controller {

  func buildContext() throws -> Context {
    return [
      "kinds": try FieldKind.all().makeNode()
    ]
  }

  func index(request: Request) throws -> ResponseRepresentable {
    let context = [
      "chapters": try Chapter.all().makeNode()
    ]

    return try drop.view.make(
      Template.Main.chapter.index,
      makeContext(from: context, request: request)
    )
  }

  func new(request: Request) throws -> ResponseRepresentable {
    let context = try buildContext()

    return try drop.view.make(
      Template.Main.chapter.new,
      makeContext(from: context, request: request)
    )
  }

  func store(request: Request) throws -> ResponseRepresentable {
    guard let node = request.formURLEncoded else {
      throw Abort.badRequest
    }

    do {
      try ChapterManager().create(node: node)
    } catch let error as InputError {
      var context = try buildContext()

      context["flash"] = "Please fill the required fields"
      context["errors"] = Node.object(error.errors)
      context["data"] = error.data

      return try drop.view.make(
        Template.Main.chapter.new,
        makeContext(from: context, request: request)
      )
    } catch {
      throw Abort.serverError
    }

    return redirect(.chapters)
  }

  func replace(request: Request, chapter: Chapter) throws -> ResponseRepresentable {
    let context = [
      "chapter": try chapter.makeNode()
    ]

    return try drop.view.make(
      Template.Main.chapter.edit,
      makeContext(from: context, request: request)
    )
  }
}

extension ChapterController: ResourceRepresentable {

  func makeResource() -> Resource<Chapter> {
    return Resource(
      index: index,
      store: store,
      replace: replace
    )
  }
}

