import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get { req -> Future<View> in
        let denmark = Country(id: 45, name: "Denmark")
        let sweden = Country(id: 46, name: "Sweden")
        let norway = Country(id: 47, name: "Norway")

        return try req.view().render("country-selector", ["countries": [denmark, sweden, norway]])
    }
}
