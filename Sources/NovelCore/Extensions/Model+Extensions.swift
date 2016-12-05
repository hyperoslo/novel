import Vapor

public extension Node {

  mutating func merge(with node: Node) {
    guard let object = node.nodeObject else {
      return
    }

    for (key, value) in object {
      self[key] = value
    }
  }
}
