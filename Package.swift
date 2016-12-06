import PackageDescription

let package = Package(
  name: "Novel",
  targets: [
    Target(name: "NovelCore"),
    Target(name: "NovelAdmin", dependencies: ["NovelCore"]),
    Target(name: "Blog", dependencies: ["NovelCore", "NovelAdmin"]),
  ],
  dependencies: [
    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 2),
    .Package(url: "https://github.com/vapor/postgresql-provider", majorVersion: 1),
    .Package(url: "https://github.com/vapor/mongo-provider.git", majorVersion: 1, minor: 1),
    .Package(url: "https://github.com/vapor/sqlite-provider.git", majorVersion: 1, minor: 1)
  ],
  exclude: [
    "Config",
    "Database",
    "Localization",
    "Public",
    "Resources",
    "Tests",
  ]
)
