import XCTest
@testable import NovelAdminTests
@testable import NovelCoreTests

XCTMain([
  // Admin
  testCase(NovelAdminTests.FeatureTests.allTests),

  // Core
  testCase(ApplicationTests.allTests),
])
