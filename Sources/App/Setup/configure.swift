import Leaf
import Vapor
import ServiceExt

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    Environment.dotenv()
    
    services.register { container -> NIOServerConfig in
        switch container.environment {
        case .production: return .default()
        default: return .default(port: 8080)
        }
    }
    
    services.register(Router.self) { container -> EngineRouter in
        let router = EngineRouter.default()
        try routes(router, container)
        return router
    }
    
    var middlewaresConfig = MiddlewareConfig()
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)
    
    try services.register(LeafProvider())
    
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}
