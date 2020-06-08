import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    router.get { req -> Future<View> in
        struct PageData: Content, Codable {
            var countries: [Country]
        }

        let client = try req.make(Client.self)
        let response = client.get("http://localhost:9090/countries")
        
        let exampleData = response.flatMap(to: [Country].self) { response in
            return try response.content.decode([Country].self)
        }.map { PageData(countries: $0) }
        
        return try req.view().render("country-selector", exampleData)
    }
}
