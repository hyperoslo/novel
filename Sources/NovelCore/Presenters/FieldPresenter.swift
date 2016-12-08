import Vapor
import Foundation

public struct FieldPresenter: Presenter {

  public typealias Key = Field.Key
  public let model: Field

  public init(model: Field) {
    self.model = model
  }

  public func makeNode() throws -> Node {
    let node = try Node(node: [
      Key.id.rawValue: model.id,
      Key.kind.rawValue: model.kind,
      Key.name.rawValue: model.name,
      Key.handle.rawValue: model.handle,
      Key.isRequired.rawValue: model.isRequired,
      Key.minLength.rawValue: model.minLength,
      Key.maxLength.rawValue: model.maxLength
      ])

    return node
  }
}
