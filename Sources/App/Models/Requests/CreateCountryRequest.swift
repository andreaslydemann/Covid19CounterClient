import Foundation
import Vapor

struct CreateCountryRequest: Content, Codable {
    let countryCode: Int
    let name: String
}
