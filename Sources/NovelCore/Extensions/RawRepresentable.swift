public extension RawRepresentable where Self.RawValue == String {

  var snaked: String {
    var result = ""

    for character in rawValue.characters {
      let string = String(character)

      guard string == string.uppercased() else {
        result.append(character)
        continue
      }

      result.append("_\(string.lowercased())")
    }

    return result
  }

  var value: String {
    return snaked
  }
}
