import Vapor

public protocol Configurator {
  func configure(drop: Droplet)
}
