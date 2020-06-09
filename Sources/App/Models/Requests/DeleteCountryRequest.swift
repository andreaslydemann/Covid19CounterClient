import Foundation
import Vapor

struct DeleteCountryRequest: Content, Codable {
    let countryCode: Int
}
