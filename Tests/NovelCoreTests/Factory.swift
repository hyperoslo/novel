import XCTest
import Vapor
import Fluent
@testable import NovelCore

func createDroplet() -> Droplet {
  let drop = Droplet()
  drop.database = Database(MemoryDriver())
  return drop
}

func createUser() throws -> NovelCore.User {
  let node = try Node(node: [
    User.Key.username.value : "admin",
    User.Key.email.value : "test@example.org",
    User.Key.password.value: "password",
    User.Key.firstname.value: "Super",
    User.Key.lastname.value: "Admin"
    ])

  return try User(node: node, in: EmptyNode)
}

func createContent() throws -> NovelCore.Content {
  let node = try Node(node: [
    Content.Key.body.value : "Content",
    Content.Key.fieldId.value: 1,
    Content.Key.entryId.value: 1,
    ])

  return try Content(node: node, in: EmptyNode)
}

func createField() throws -> NovelCore.Field {
  let node = try! Node(node: [
    Field.Key.kind.value : FieldKind.plainText.rawValue,
    Field.Key.name.value: "Title",
    Field.Key.handle.value: "title",
    Field.Key.isRequired.value: true,
    Field.Key.minLength.value: 5,
    Field.Key.maxLength.value: 20,
    Field.Key.prototypeId.value: 1
    ])

  return try! Field(node: node, in: EmptyNode)
}

func createPrototype() throws -> NovelCore.Prototype {
  let node = try! Node(node: [
    Prototype.Key.name.value : "Post",
    Prototype.Key.handle.value: "post",
    Prototype.Key.description.value: "Text",
    ])

  return try! Prototype(node: node, in: EmptyNode)
}
