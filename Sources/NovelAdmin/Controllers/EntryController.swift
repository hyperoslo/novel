import Vapor
import HTTP
import NovelCore

final class EntryController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    let context = [
      "chapters": try Chapter.all().makeNode(),
      "entries": try Entry.all().makeNode()
    ]

    return try drop.view.make(
      Template.Main.entry.index,
      makeContext(from: context, request: request)
    )
  }

  func index(request: Request, chapter: Chapter) throws -> ResponseRepresentable {
    let context = [
      "chapters": try Chapter.all().makeNode(),
      "entries": try chapter.entries().all().makeNode(),
    ]

    return try drop.view.make(
      Template.Main.entry.index,
      makeContext(from: context, request: request)
    )
  }

  func new(request: Request, chapter: Chapter) throws -> ResponseRepresentable {
    let context = [
      "chapter": try chapter.makeNode(),
      "fields": try chapter.fields().all().makeNode()
    ]

    return try drop.view.make(
      Template.Main.entry.new,
      makeContext(from: context, request: request)
    )
  }

  func store(request: Request, chapter: Chapter) throws -> ResponseRepresentable {
    guard let node = request.formURLEncoded else {
      throw Abort.badRequest
    }

    do {
      try EntryManager().create(chapter: chapter, node: node)
    } catch let error as InputError {
      let context = [
        "data": node,
        "chapter": try chapter.makeNode(),
        "fields": try chapter.fields().all().makeNode(),
        "flash": "Please fill the required fields",
        "errors": Node.object(error.errors)
      ]

      return try drop.view.make(
        Template.Main.entry.new,
        makeContext(from: context, request: request)
      )
    } catch {
      throw Abort.serverError
    }

    return redirect(.entries)
  }

  func show(request: Request, entry: Entry) throws -> ResponseRepresentable {
    var context: Context = [
      "entry": try entry.makeNode()
    ]

    if let chapter = try entry.chapter().get() {
      context["chapter"] = try chapter.makeNode()
      context["fields"] = try chapter.fields().all().makeNode()
    }

    return try drop.view.make(
      Template.Main.entry.show,
      makeContext(from: context, request: request)
    )
  }

  func replace(request: Request, entry: Entry) throws -> ResponseRepresentable {
    guard let node = request.formURLEncoded, let chapter = try entry.chapter().get() else {
      throw Abort.badRequest
    }

    do {
      try EntryManager().update(entry: entry, node: node)
    } catch let error as InputError {
      let context = [
        "data": node,
        "chapter": try chapter.makeNode(),
        "fields": try chapter.fields().all().makeNode(),
        "flash": "Please fill the required fields",
        "errors": Node.object(error.errors)
      ]

      return try drop.view.make(
        Template.Main.entry.new,
        makeContext(from: context, request: request)
      )
    } catch {
      throw Abort.serverError
    }

    return redirect(.entries, id: entry.id)
  }
}

extension EntryController: ResourceRepresentable {

  func makeResource() -> Resource<Entry> {
    return Resource(
      index: index,
      show: show,
      replace: replace
    )
  }
}
