import App
import Foundation

do {
    try app(.detect()).run()
} catch {
    print(error)
    exit(1)
}
