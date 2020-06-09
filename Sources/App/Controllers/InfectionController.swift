import Vapor

struct InfectionController: RouteCollection {
    let apiBaseUrl: String
    
    init(apiBaseUrl: String) {
        self.apiBaseUrl = apiBaseUrl
    }
    
    func boot(router: Router) throws {
        let countriesRouter = router.grouped("infections")
        
        countriesRouter.get(Int.parameter, use: getInfections)
        countriesRouter.post(Int.parameter, "increment", use: increment)
        countriesRouter.post(Int.parameter, "decrement", use: decrement)
    }
}

private extension InfectionController {
    func getInfections(_ req: Request) throws -> Future<View> {
        struct PageData: Content, Codable {
            var infection: Infection
        }
        
        let countryCode = try req.parameters.next(Int.self)
        
        let client = try req.make(Client.self)
        let response = client.get("\(apiBaseUrl)/infections/\(countryCode)")
        
        let pageData = response.flatMap(to: Infection.self) { response in
            return try response.content.decode(Infection.self)
        }.map { PageData(infection: $0) }
        
        return try req.view().render("infection-counter", pageData)
    }
    
    func increment(_ req: Request) throws -> Future<Response> {
        let countryCode = try req.parameters.next(Int.self)
        
        let modifyRequest = ModifyInfectionRequest(countryCode: countryCode)
        
        let client = try req.make(Client.self)
        
        let response = client.post("\(apiBaseUrl)/infections/increment") { post in
            try post.content.encode(modifyRequest)
        }
        
        return response.map(to: Response.self) { res in
            return req.redirect(to: "/infections/\(countryCode)")
        }
    }
    
    func decrement(_ req: Request) throws -> Future<Response> {
        let countryCode = try req.parameters.next(Int.self)
        
        let modifyRequest = ModifyInfectionRequest(countryCode: countryCode)
        
        let client = try req.make(Client.self)
        
        let response = client.post("\(apiBaseUrl)/infections/decrement") { post in
            try post.content.encode(modifyRequest)
        }
        
        return response.map(to: Response.self) { res in
            return req.redirect(to: "/infections/\(countryCode)")
        }
    }
}
