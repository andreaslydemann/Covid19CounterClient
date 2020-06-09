import Foundation
import Vapor

struct ModifyInfectionRequest: Content, Codable {
    let countryCode: Int
}
