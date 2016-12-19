import Vapor
import Fluent
import HTTP
import Turnstile
import TurnstileCrypto
import TurnstileWeb
import Auth

public final class User: Model {

  public enum Key: String {
    case username
    case email
    case password
    case firstname
    case lastname
  }

  public enum Error: Swift.Error {
    case invalidUserType
  }

  // Fields
  public var username: String
  public var email: String
  public var password: String = ""
  public var firstname: String
  public var lastname: String

  public var name: String {
    return "\(firstname) \(lastname)"
  }

  /**
    Initializer.
   */
  public required init(node: Node, in context: Context) throws {
    username = try node.extract(Key.username.value)
    email = try node.extract(Key.email.value)
    password = try node.extract(Key.password.value)
    firstname = node[Key.firstname.value]?.string ?? ""
    lastname = node[Key.lastname.value]?.string ?? ""
    try super.init(node: node, in: context)
    validator = UserValidator.self
  }

  /**
    Serialization.
   */
  public override func makeNode() throws -> Node {
    return try Node(node: [
      Key.username.value: username,
      Key.email.value: email,
      Key.password.value: password,
      Key.firstname.value: firstname,
      Key.lastname.value: lastname])
  }

  /**
   Preparation.
   */
  public override class func create(schema: Schema.Creator) throws {
    schema.string(Key.username.value, length: 50, unique: true)
    schema.string(Key.email.value, length: 50, unique: true)
    schema.string(Key.password.value)
    schema.string(Key.firstname.value, length: 50)
    schema.string(Key.lastname.value, length: 50)
  }
}

// MARK: - Authentication

extension User: Auth.User {

  /**
    Authenticates the user with given credentials.
  */
  public static func authenticate(credentials: Credentials) throws -> Auth.User {
    var identity: User?

    switch credentials {
    // Tries to authenticate the user with username and password
    case let credentials as UsernamePassword:
      identity = try findIdentity(with: credentials)
    case let node as Node:
      guard let credentials = try? node.credentials() else { break }
      identity = try findIdentity(with: credentials)
    // Fetches the user by session ID
    case let credentials as Identifier:
      identity = try User.find(credentials.id)
    // Credentials type is not supported yet
    default:
      throw UnsupportedCredentialsError()
    }

    guard let user = identity else {
      throw IncorrectCredentialsError()
    }

    return user
  }

  /**
   Registers the user with credentials.
   */
  public static func register(credentials: Credentials) throws -> Auth.User {
    var user: User

    switch credentials {
    case let node as Node:
      user = try User(node: node)
      user.password = BCrypt.hash(password: user.password)
    default:
      throw UnsupportedCredentialsError()
    }

    guard try User.query().filter(Key.email.value, user.email).first() == nil else {
      throw AccountTakenError()
    }

    guard try User.query().filter(Key.username.value, user.username).first() == nil else {
      throw AccountTakenError()
    }

    try user.save()
    return user
  }

  public static func findIdentity(with credentials: UsernamePassword) throws -> User? {
    var user: User?

    if let foundUser = try User.query().filter(Key.email.value, credentials.username).first() {
      user = foundUser
    } else if let foundUser = try User.query().filter(Key.username.value, credentials.username).first() {
      user = foundUser
    }

    guard
      let identity = user,
      !identity.password.isEmpty,
      (try? BCrypt.verify(password: credentials.password, matchesHash: identity.password)) == true
      else {
        return nil
    }

    return user
  }
}

// MARK: - Request

extension Request {

  public func user() throws -> User {
    guard let user = try auth.user() as? User else {
      throw User.Error.invalidUserType
    }

    return user
  }
}

// MARK: - Node

extension Node: Credentials {

  fileprivate func credentials() throws -> UsernamePassword {
    return UsernamePassword(
      username: try extract(User.Key.username.value),
      password: try extract(User.Key.password.value)
    )
  }
}
