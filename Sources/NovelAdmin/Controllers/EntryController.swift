import Vapor
import HTTP
import NovelCore

final class EntryController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    let context: Context = [
      "chapters": try Chapter.all().makeNode(),
      "entries": try EntryPresenter.makeNodes(from: try Entry.all())
    ]

    return try drop.view.make(
      Template.Main.entry.index,
      makeContext(from: context, request: request)
    )
  }

  func index(request: Request, chapter: Chapter) throws -> ResponseRepresentable {
    let context = [
      "chapters": try Chapter.all().makeNode(),
      "entries": try EntryPresenter.makeNodes(from: try chapter.entries().all())
    ]

    return try drop.view.make(
      Template.Main.entry.index,
      makeContext(from: context, request: request)
    )
  }

  func new(request: Request, chapter: Chapter) throws -> ResponseRepresentable {
    let context = [
      "entry": try EntryPresenter(model: Entry.new()).makeNode()
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

    let entry = try Entry.new()
    let manager = EntryManager(entry: entry)

    do {
      try manager.create(from: node, chapter: chapter)
    } catch let error as InputError {
      let context = [
        "entry": try EntryPresenter(model: manager.entry).makeNode(),
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

  func show(request: Request, chapter: Chapter, entry: Entry) throws -> ResponseRepresentable {
    let context: Context = [
      "entry": try EntryPresenter(model: entry).makeNode()
    ]

    return try drop.view.make(
      Template.Main.entry.show,
      makeContext(from: context, request: request)
    )
  }

  func replace(request: Request, chapter: Chapter, entry: Entry) throws -> ResponseRepresentable {
    guard let node = request.formURLEncoded else {
      throw Abort.badRequest
    }

    let manager = EntryManager(entry: entry)

    do {
      try manager.update(from: node)
    } catch let error as InputError {
      let context = [
        "entry": try EntryPresenter(model: manager.entry).makeNode(),
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
