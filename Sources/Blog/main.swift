import Vapor
import NovelCore
import NovelAdmin

let app = Application()
app.configurators = [AdminConfigurator()]
try app.start()
