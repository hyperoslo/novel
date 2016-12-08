import Foundation
import Cache
import Node

public final class SessionCache: CacheProtocol {
  private var storage: [String: Node]

  public init() {
    storage = [:]
  }

  public func get(_ key: String) throws -> Node? {
    if let token = storage[key] {
      return token
    }

    let session = try Session.query().filter(Session.Key.token.value, key).first()
    return try session?.user().get()?.id
  }

  public func set(_ key: String, _ value: Node) throws {
    storage[key] = value

    let node: Node = [
      Session.Key.token.value: Node.string(key),
      Session.Key.userId.value: value
    ]

    try Session.query().filter(Session.Key.userId.value, value).delete()
    var session = try Session(node: node)
    try session.save()
  }

  public func delete(_ key: String) throws {
    storage.removeValue(forKey: key)
    try Session.query().filter(Session.Key.token.value, key).delete()
  }
}
