import Foundation
import Vapor

struct Infection: Content, Codable {
    let id: Int
    let count: Int
    let countryCode: Int
}
