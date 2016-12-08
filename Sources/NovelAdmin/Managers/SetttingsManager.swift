import Vapor
import NovelCore

struct SettingsManager {

  enum SetupError: Error{
    case missingFields
  }

  @discardableResult func create(node: Node) throws {
    let validator = SetupValidator(node: node)

    guard
      let name = node[Setting.General.siteName.value]?.string,
      let url = node[Setting.General.siteUrl.value]?.string
      else {
        throw SetupError.missingFields
    }

    guard validator.isValid else {
      let data = validator.node
      throw InputError(data: data, errors: validator.errors)
    }

    let siteName = try Node(node: [
      Setting.Key.name.value : Setting.General.siteName.title,
      Setting.Key.handle.value : Setting.General.siteName.rawValue,
      Setting.Key.value.value : name
      ])

    let siteUrl = try Node(node: [
      Setting.Key.name.value : Setting.General.siteUrl.title,
      Setting.Key.handle.value : Setting.General.siteUrl.rawValue,
      Setting.Key.value.value : url
      ])

    for settingNode in [siteName, siteUrl] {
      var setting = try Setting(node: settingNode)
      try setting.save()
    }
  }
}
