import Vapor
import NovelCore

struct ContentValidator: NodeValidator {

  let node: Node
  var errors: [String: Node] = [:]

  init(node: Node) {
    self.node = node
  }
}
