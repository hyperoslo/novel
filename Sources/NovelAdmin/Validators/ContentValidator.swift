import Vapor
import NovelCore

struct ContentValidator: NodeValidator {

  static func transform(node: Node) -> Node {
    return Node.object(["body": node])
  }

  let node: Node
  var errors: [String: Node] = [:]

  init(node: Node) {
    self.node = node
  }
}
