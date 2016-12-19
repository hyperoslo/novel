import XCTest
import Vapor
import Fluent
@testable import NovelCore

final class TestConfigurator: Configurator {

  var isConfigured = false

  func configure(drop: Droplet) throws {
    isConfigured = true
  }
}

final class TestFeature: Feature {

  let configurators: [Configurator] = [
    TestConfigurator()
  ]
}

final class TestController: Controller {}

import NovelCore

enum TestRoute: String, RouteRepresentable  {
  case users

  static var root: String {
    return "/admin"
  }
}

// MARK: - Extension

extension XCTestCase {

  func testField(in schema: Schema.Creator,
                 index: Int,
                 name: String,
                 type: Schema.Field.DataType,
                 optional: Bool = false,
                 unique: Bool = false,
                 default: NodeRepresentable? = nil) {
    guard schema.fields.count > index else {
      XCTFail("Field does not exist in \(schema)")
      return
    }

    let field = schema.fields[index]
    XCTAssertEqual(field.name, name)
    XCTAssertEqual(field.optional, optional)
    XCTAssertEqual(field.unique, unique)
    XCTAssertEqual(field.default, try! `default`?.makeNode())

    // Test type
    switch field.type {
    case .id:
      switch type {
      case .id: break
      default:
        XCTFail("Field type must be `\(type)`")
      }
    case .int:
      switch type {
      case .int: break
      default:
        XCTFail("Field type must be `\(type)`")
      }
    case .string(let length1):
      switch type {
      case .string(let length2):
        XCTAssertEqual(length1, length2)
      default:
        XCTFail("Field type must be `\(type)`")
      }
    case .double:
      switch type {
      case .double: break
      default:
        XCTFail("Field type must be `\(type)`")
      }
    case .bool:
      switch type {
      case .bool: break
      default:
        XCTFail("Field type must be `\(type)`")
      }
    case .data:
      switch type {
      case .data: break
      default:
        XCTFail("Field type must be `\(type)`")
      }
    case .custom(let type1):
      switch type {
      case .custom(let type2):
        XCTAssertEqual(type1, type2)
      default:
        XCTFail("Field type must be `\(type)`")
      }
    }
  }
}
