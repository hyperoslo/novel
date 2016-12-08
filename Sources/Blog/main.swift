import Vapor
import NovelCore
import NovelAdmin
import NovelAPI
import Novel

let app = Application()

app.features = [
  NovelAdmin.Feature(),
  NovelAPI.Feature(),
  Novel.NovelAdmin.Feature()
]



try app.start()
