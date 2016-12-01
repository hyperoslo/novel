import Vapor
import NovelCore

struct EntryManager {

  @discardableResult func create(node: Node) throws -> Entry {
    let entryValidator = EntryValidator(node: node)
    var entry = try ModelBuilder<Entry>(validator: entryValidator).build()
    //var contents: [NovelCore.Content] = []

    //for contentNode in entryValidator.contentNodes {

    //}

    try entry.save()

    return entry
  }
}
