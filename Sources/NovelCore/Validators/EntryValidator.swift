import Vapor

public struct EntryValidator: NodeValidator {

  public var node: Node
  public var errors: [String: Node] = [:]
  public var contentNodes: [Node] = []

  public init(node: Node) {
    self.node = node
    validate(key: Entry.Key.title.value, by: Count<String>.containedIn(low: 1, high: 100))
  }
}
