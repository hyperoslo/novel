import NovelCore
import NovelAdmin
import NovelAPI
import NovelTheme

let app = Application()

app.features = [
  NovelAdmin.Feature(),
  NovelAPI.Feature(),
  NovelTheme.Feature()
]

try app.start()
