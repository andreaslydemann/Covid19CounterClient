import Vapor

struct CountryController: RouteCollection {
    let apiBaseUrl: String
    
    init(apiBaseUrl: String) {
        self.apiBaseUrl = apiBaseUrl
    }
    
    func boot(router: Router) throws {
        let countriesRouter = router.grouped("")
        
        countriesRouter.get(use: getCountries)
        countriesRouter.post(CreateCountryRequest.self, at: "add", use: createCountry)
        countriesRouter.post("delete", Int.parameter, use: deleteCountry)
    }
}

private extension CountryController {
    func getCountries(_ req: Request) throws -> Future<View> {
        struct PageData: Content, Codable {
            var countries: [Country]
        }

        let client = try req.make(Client.self)
        let response = client.get("\(apiBaseUrl)/countries")
        
        let pageData = response.flatMap(to: [Country].self) { response in
            return try response.content.decode([Country].self)
        }.map { PageData(countries: $0) }
        
        return try req.view().render("country-selector", pageData)
    }
    
    func createCountry(_ req: Request, country: CreateCountryRequest) throws -> Future<Response> {
        let client = try req.make(Client.self)
        
        let response = client.post("\(apiBaseUrl)/countries") { post in
            try post.content.encode(country)
        }
        
        return response.map(to: Response.self) { res in
            return req.redirect(to: "/")
        }
    }
    
    func deleteCountry(_ req: Request) throws -> Future<Response> {
        let countryCode = try req.parameters.next(Int.self)
        let deleteRequest = DeleteCountryRequest(countryCode: countryCode)
        
        let client = try req.make(Client.self)
        
        let response = client.delete("\(apiBaseUrl)/countries/\(countryCode)") { delete in
            try delete.content.encode(deleteRequest)
        }
        
        return response.map(to: Response.self) { res in
            return req.redirect(to: "/")
        }
    }
}
