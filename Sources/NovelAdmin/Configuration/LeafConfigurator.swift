import Vapor
import Leaf
import NovelCore

struct LeafConfigurator: Configurator {

  func configure(drop: Droplet) {
    guard let renderer = drop.view as? LeafRenderer else {
      return
    }

    let tags: [Tag] = [
      AdminPathTag(),
      LoginPathTag(),
      LogoutPathTag(),
      SignupPathTag(),
      ResetPathTag(),
      ProfilePathTag()
    ]

    tags.forEach { tag in
      renderer.stem.register(tag)
    }
  }
}
