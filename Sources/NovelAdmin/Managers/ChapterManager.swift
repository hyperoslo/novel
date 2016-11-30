import Vapor
import NovelCore

struct ChapterManager {

  @discardableResult func create(node: Node) throws -> Chapter {
    let chapterValidator = ChapterValidator(node: node)
    var chapter = try ModelBuilder<Chapter>(validator: chapterValidator).build()
    var fields: [Field] = []

    for fieldNode in chapterValidator.fieldNodes {
      let field = try ModelBuilder<Field>(validator: FieldValidator(node: fieldNode)).build()
      fields.append(field)
    }

    try chapter.save()

    for var field in fields {
      field.set(chapter: chapter)
      try field.save()
    }

    return chapter
  }
}
