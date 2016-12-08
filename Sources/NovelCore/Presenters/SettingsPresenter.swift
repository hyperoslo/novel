import Vapor

public struct SettingsPresenter {

  public init() {}

  public func general() throws -> Node {
    let siteName = try Setting.query().filter(
      Setting.Key.handle.value, Setting.General.siteName.rawValue).first()?.value
    let siteUrl = try Setting.query().filter(
      Setting.Key.handle.value, Setting.General.siteUrl.rawValue).first()?.value

    return try Node(node: [
      Setting.General.siteName.value : siteName ?? "",
      Setting.General.siteUrl.value : siteUrl ?? "",
      ])
  }
}
