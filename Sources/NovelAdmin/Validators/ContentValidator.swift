import Vapor
import NovelCore

struct ContentValidator: NodeValidator {

  let node: Node
  var errors: [String: Node] = [:]

  init(node: Node) {
    let body = node.string ?? ""
    self.node = Node.object(["body": Node.string(body)])
  }
}
