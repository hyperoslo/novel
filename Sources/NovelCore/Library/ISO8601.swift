import Foundation

public struct ISO8601 {
  public static let shared = ISO8601()
  public let formatter: DateFormatter

  public init() {
    formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
  }
}

extension Date {
  public var iso8601: String {
    return ISO8601.shared.formatter.string(from: self)
  }

  public init?(iso8601: String) {
    guard let date = ISO8601.shared.formatter.date(from: iso8601) else {
      return nil
    }

    self = date
  }
}

extension String {
  var iso8601: Date? {
    return Date(iso8601: self)
  }
}
