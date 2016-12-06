import Vapor

public struct ContentValidator: NodeValidator {

  public let node: Node
  public var errors: [String: Node] = [:]

  public init(node: Node) {
    self.node = node
  }
}
