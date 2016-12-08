import Vapor
import HTTP
import NovelCore

final class UserController: Controller {

  func index(request: Request) throws -> ResponseRepresentable {
    let context = [
      "users": try User.all().makeNode()
    ]

    return try drop.view.make(
      Template.Main.user.index,
      makeContext(from: context, request: request)
    )
  }

  func show(request: Request, user: User) throws -> ResponseRepresentable {
    let context = [
      "user": try user.makeNode()
    ]

    return try drop.view.make(
      Template.Main.user.index,
      makeContext(from: context, request: request)
    )
  }
}

extension UserController: ResourceRepresentable {

  func makeResource() -> Resource<User> {
    return Resource(
      index: index,
      show: show
    )
  }
}
