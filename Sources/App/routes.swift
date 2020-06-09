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
    
    router.post(CountryRequest.self, at: "add") { req, country -> Future<Response> in
        let client = try req.make(Client.self)
        
        let response = client.post("http://localhost:9090/countries") { post in
            try post.content.encode(country)
        }
        
        return response.map(to: Response.self) { res in
            return req.redirect(to: "/")
        }
    }
    
    router.get("infections", Int.parameter) { req -> Future<View> in
        return try req.view().render("infection-counter")
    }
}
