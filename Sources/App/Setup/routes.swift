import Vapor

public func routes(_ router: Router, _ container: Container) throws {
    guard let apiBaseUrl: String = Environment.get("API_BASE_URL") else {
        throw Abort(.internalServerError)
    }
    
    try router.register(collection: CountryController(apiBaseUrl: apiBaseUrl))
    try router.register(collection: InfectionController(apiBaseUrl: apiBaseUrl))
    router.get("status") { (req) -> HTTPStatus in
        return .ok
    }
}
