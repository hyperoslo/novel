import Node

public enum FieldKind: Int {
  case plainText
  case richText
  case date
  case number
  case flag
  case reference

  public enum Key: String {
    case id
    case title
  }

  public static func all() -> [FieldKind] {
    return [
      .plainText,
      .richText
    ]
  }
}

extension FieldKind: CustomStringConvertible {

  public var description: String {
    let result: String

    switch self {
    case .plainText:
      result = "Plain Text"
    case .richText:
      result = "Rich Text"
    case .date:
      result = "Date"
    case .number:
      result = "Number"
    case .flag:
      result = "Flag"
    case .reference:
      result = "Reference"
    }

    return result
  }
}

extension FieldKind: NodeRepresentable {

  public func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      Key.id.snaked: rawValue,
      Key.title.snaked: description
      ])
  }
}
