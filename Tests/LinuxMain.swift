import XCTest
@testable import NovelAdminTests
@testable import NovelCoreTests

XCTMain([
  // Admin
  testCase(NovelAdminTests.FeatureTests.allTests),

  // Core
  testCase(NovelCoreTests.ApplicationTests.allTests),
  testCase(NovelCoreTests.MiddlewareConfiguratorTests.allTests),
  testCase(NovelCoreTests.AuthHelperTests.allTests),
  testCase(NovelCoreTests.NodeTests.allTests),
  testCase(NovelCoreTests.RawRepresentableTests.allTests),
  testCase(NovelCoreTests.SchemaTests.allTests),
  testCase(NovelCoreTests.ControllerTests.allTests),
  testCase(NovelCoreTests.ISO8601Tests.allTests),
  testCase(NovelCoreTests.RouteRepresentableTests.allTests),
  testCase(NovelCoreTests.SessionCacheTests.allTests),
  testCase(NovelCoreTests.SetupMonitorTests.allTests),
  testCase(NovelCoreTests.FallbackMiddlewareTests.allTests),
  testCase(NovelCoreTests.ContentTests.allTests),
  testCase(NovelCoreTests.EntryTests.allTests),
  testCase(NovelCoreTests.FieldKindTests.allTests),
  testCase(NovelCoreTests.FieldTests.allTests),
  testCase(NovelCoreTests.ModelTests.allTests),
  testCase(NovelCoreTests.PrototypeTests.allTests),
  testCase(NovelCoreTests.SessionTests.allTests),
  testCase(NovelCoreTests.SettingTests.allTests),
  testCase(NovelCoreTests.UserTests.allTests),
  testCase(NovelCoreTests.ContentPresenterTests.allTests),
  testCase(NovelCoreTests.EntryPresenterTests.allTests),
  testCase(NovelCoreTests.FieldPresenterTests.allTests),
  testCase(NovelCoreTests.PrototypePresenterTests.allTests),
  testCase(NovelCoreTests.SettingsPresenterTests.allTests),
  testCase(NovelCoreTests.EntryValidatorTests.allTests),
  testCase(NovelCoreTests.FieldValidatorTests.allTests),
  testCase(NovelCoreTests.PrototypeValidatorTests.allTests),
  testCase(NovelCoreTests.SettingValidatorTests.allTests),
  testCase(NovelCoreTests.SetupValidatorTests.allTests),
  testCase(NovelCoreTests.UserValidatorTests.allTests),
  testCase(NovelCoreTests.FieldValidationTests.allTests),
  testCase(NovelCoreTests.NameValidationTests.allTests),
  testCase(NovelCoreTests.NodeValidationTests.allTests),
  testCase(NovelCoreTests.PasswordValidationTests.allTests)
])
