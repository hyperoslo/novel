import HTTP

public struct FallbackMiddleware: Middleware {

  public typealias Validation = (Request) -> Bool

  public let fallback: String
  public let isAllowed: Validation

  public init(fallback: String, isAllowed: @escaping Validation) {
    self.fallback = fallback
    self.isAllowed = isAllowed
  }

  public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
    guard isAllowed(request) else {
      return Response(redirect: fallback)
    }

    return try next.respond(to: request)
  }
}
