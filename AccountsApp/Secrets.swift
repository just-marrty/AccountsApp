import Foundation

// Ujisti se, že .env je přidán do projektu jako Resource a je součástí targetu v Xcode!
enum Secrets {
    static var apiKey: String {
        guard
            let url = Bundle.main.url(forResource: ".env", withExtension: nil),
            let content = try? String(contentsOf: url, encoding: .utf8),
            let line = content.split(separator: "\n").first(where: { $0.contains("API_KEY=") }),
            let key = line.split(separator: "=").last
        else {
            fatalError("API klíč nebyl nalezen v .env souboru v bundlu aplikace. Přidej .env do Resources a do targetu v Xcode.")
        }
        return String(key)
    }
}
