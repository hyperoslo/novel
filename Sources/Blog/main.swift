import Vapor
import NovelCore
import NovelAdmin
import NovelAPI

let app = Application()

app.features = [
  NovelAdmin.Feature(),
  NovelAPI.Feature()
]

try app.start()
