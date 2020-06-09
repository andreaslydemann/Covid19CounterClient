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
        
        let pageData = response.flatMap(to: [Country].self) { response in
            return try response.content.decode([Country].self)
        }.map { PageData(countries: $0) }
        
        return try req.view().render("country-selector", pageData)
    }
    
    router.post(CreateCountryRequest.self, at: "add") { req, country -> Future<Response> in
        let client = try req.make(Client.self)
        
        let response = client.post("http://localhost:9090/countries") { post in
            try post.content.encode(country)
        }
        
        return response.map(to: Response.self) { res in
            return req.redirect(to: "/")
        }
    }
    
    router.post("delete", Int.parameter)  { req -> Future<Response> in
        let countryCode = try req.parameters.next(Int.self)
        let deleteRequest = DeleteCountryRequest(countryCode: countryCode)
        
        let client = try req.make(Client.self)
        
        let response = client.delete("http://localhost:9090/countries/\(countryCode)") { delete in
            try delete.content.encode(deleteRequest)
        }
        
        return response.map(to: Response.self) { res in
            return req.redirect(to: "/")
        }
    }
    
    router.get("infections", Int.parameter) { req -> Future<View> in
        struct PageData: Content, Codable {
            var infection: Infection
        }
        
        let countryCode = try req.parameters.next(Int.self)
        
        let client = try req.make(Client.self)
        let response = client.get("http://localhost:9090/infections/\(countryCode)")
        
        let pageData = response.flatMap(to: Infection.self) { response in
            return try response.content.decode(Infection.self)
        }.map { PageData(infection: $0) }
        
        return try req.view().render("infection-counter", pageData)
    }
    
    router.post("infections", Int.parameter, "increment") { req -> Future<Response> in
        let countryCode = try req.parameters.next(Int.self)
        
        let modifyRequest = ModifyInfectionRequest(countryCode: countryCode)
        
        let client = try req.make(Client.self)
        
        let response = client.post("http://localhost:9090/infections/increment") { post in
            try post.content.encode(modifyRequest)
        }
        
        return response.map(to: Response.self) { res in
            return req.redirect(to: "/infections/\(countryCode)")
        }
    }
    
    router.post("infections", Int.parameter, "decrement") { req -> Future<Response> in
        let countryCode = try req.parameters.next(Int.self)
        
        let modifyRequest = ModifyInfectionRequest(countryCode: countryCode)
        
        let client = try req.make(Client.self)
        
        let response = client.post("http://localhost:9090/infections/decrement") { post in
            try post.content.encode(modifyRequest)
        }
        
        return response.map(to: Response.self) { res in
            return req.redirect(to: "/infections/\(countryCode)")
        }
    }
}
