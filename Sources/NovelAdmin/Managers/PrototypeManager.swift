import Vapor
import NovelCore

struct PrototypeManager {

  @discardableResult func create(node: Node) throws -> Prototype {
    let prototypeValidator = PrototypeValidator(node: node)
    var prototype = try ModelBuilder<Prototype>(validator: prototypeValidator).build()
    var fields: [Field] = []

    for fieldNode in prototypeValidator.fieldNodes {
      let field = try ModelBuilder<Field>(validator: FieldValidator(node: fieldNode)).build()
      fields.append(field)
    }

    try prototype.save()

    for var field in fields {
      field.set(prototype: prototype)
      try field.save()
    }

    return prototype
  }
}
