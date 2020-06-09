import Foundation
import Vapor

struct CountryRequest: Content, Codable {
    let countryCode: Int
    let name: String
}
