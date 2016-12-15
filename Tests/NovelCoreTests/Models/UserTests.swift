import XCTest
import Fluent
import Auth
import Turnstile
import HTTP
@testable import NovelCore

typealias User = NovelCore.User

class UserTests: XCTestCase {

  typealias Key = User.Key

  static let allTests = [
    ("testInitWhenValid", testInitWhenValid),
    ("testInitWhenInvalid", testInitWhenInvalid),
    ("testName", testName),
    ("testMakeNode", testMakeNode),
    ("testCreate", testCreate)
  ]

  var node: Node!
  var entity: User!

  override func setUp() {
    super.setUp()

    node = try! Node(node: [
      Key.username.value : "admin",
      Key.email.value: "test@example.org",
      Key.password.value: "secret",
      Key.firstname.value: "Super",
      Key.lastname.value: "Admin"
    ])

    entity = try! User(node: node, in: EmptyNode)
    User.database = Database(MemoryDriver())
  }

  override func tearDown() {
    super.tearDown()
    User.database = nil
  }

  // MARK: - Tests

  func testInitWhenValid() throws {
    XCTAssertEqual(entity.username, "admin")
    XCTAssertEqual(entity.email, "test@example.org")
    XCTAssertEqual(entity.password, "secret")
    XCTAssertEqual(entity.firstname, "Super")
    XCTAssertEqual(entity.lastname, "Admin")
  }

  func testInitWhenInvalid() throws {
    let node = try! Node(node: [])

    do {
      _ = try Field(node: node, in: EmptyNode)
      XCTFail("Init must fail with error")
    } catch {
      XCTAssertTrue(error is NodeError)
    }
  }

  func testName() throws {
    XCTAssertEqual(entity.name, "\(entity.firstname) \(entity.lastname)")
  }

  func testMakeNode() throws {
    let result = try entity.makeNode()

    XCTAssertEqual(result.object?.count, 5)
    XCTAssertEqual(result[Key.username.value], "admin")
    XCTAssertEqual(result[Key.email.value], "test@example.org")
    XCTAssertEqual(result[Key.password.value], "secret")
    XCTAssertEqual(result[Key.firstname.value], "Super")
    XCTAssertEqual(result[Key.lastname.value], "Admin")
  }

  func testCreate() throws {
    let schema = Schema.Creator("users")
    try User.create(schema: schema)

    XCTAssertEqual(schema.fields.count, 5)
    testField(in: schema, index: 0, name: Key.username.value, type: .string(length: 50), unique: true)
    testField(in: schema, index: 1, name: Key.email.value, type: .string(length: 50), unique: true)
    testField(in: schema, index: 2, name: Key.password.value, type: .string(length: nil))
    testField(in: schema, index: 3, name: Key.firstname.value, type: .string(length: 50))
    testField(in: schema, index: 4, name: Key.lastname.value, type: .string(length: 50))
  }

  // MARK: - Authentication

  func testAuthenticateWithNode() throws {
    let user = try register()
    let result = try User.authenticate(credentials: [
      "username": user.username,
      "password": "secret",
    ].makeNode())
    XCTAssertEqual(result.uniqueID, user.id?.string)
    try user.delete()
  }

  func testAuthenticateWithUsernamePassword() throws {
    let user = try register()
    let credentials = UsernamePassword(username: "admin", password: "secret")
    let result = try User.authenticate(credentials: credentials)
    XCTAssertEqual(result.uniqueID, user.id?.string)
    try user.delete()
  }

  func testAuthenticateWithNoUser() throws {
    let credentials = UsernamePassword(username: "admin", password: "secret")
    do {
      _ = try User.authenticate(credentials: credentials)
      XCTFail("Must throw an error")
    } catch {
      XCTAssertTrue(error is IncorrectCredentialsError)
    }
  }

  func testRegister() throws {
    let user = try register()
    XCTAssertNotNil(user.id)
    try user.delete()
  }

  func testRegisterWithUnsupportedCredentials() throws {
    let credentials = UsernamePassword(username: "admin", password: "secret")
    do {
      _ = try User.register(credentials: credentials)
      XCTFail("Must throw an error")
    } catch {
      XCTAssertTrue(error is UnsupportedCredentialsError)
    }
  }

  func testRegisterWhenEmailTaken() throws {
    try register()
    let user = try createUser()
    user.username = "test"
    let node = try user.makeNode()

    do {
      _ = try User.register(credentials: node)
      XCTFail("Must throw an error")
    } catch {
      XCTAssertTrue(error is AccountTakenError)
    }
  }

  func testRegisterWhenUsernameTaken() throws {
    try register()
    let user = try createUser()
    user.email = "test1@example.org"
    let node = try user.makeNode()

    do {
      _ = try User.register(credentials: node)
      XCTFail("Must throw an error")
    } catch {
      XCTAssertTrue(error is AccountTakenError)
    }
  }

  func findIdentityByEmail() throws {
    let user = try register()
    let credentials = UsernamePassword(username: "test@example.org", password: "secret")
    let result = try User.findIdentity(with: credentials)
    XCTAssertEqual(result?.uniqueID, user.id?.string)
    try user.delete()
  }

  func findIdentityByUsername() throws {
    let user = try register()
    let credentials = UsernamePassword(username: "admin", password: "secret")
    let result = try User.findIdentity(with: credentials)
    XCTAssertEqual(result?.uniqueID, user.id?.string)
    try user.delete()
  }

  func findIdentityWithNoUser() throws {
    let credentials = UsernamePassword(username: "test@example.org", password: "secret")
    let result = try User.findIdentity(with: credentials)
    XCTAssertNil(result)
  }

  func testRequestUserWhenNotAuthenticated() throws {
    let request = try Request(method: .get, uri: "http://hyper.no")

    do {
      _ = try request.user()
      XCTFail("Must throw an error")
    } catch {
      XCTAssertTrue(error is Auth.AuthError)
    }
  }

  // MARK: - Helper

  @discardableResult func register() throws -> User {
    let user = try createUser()
    let node = try user.makeNode()
    return try User.register(credentials: node) as! User
  }
}
