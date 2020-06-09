import Foundation
import Vapor

struct Country: Content, Codable {
    let id: Int
    let name: String
}
