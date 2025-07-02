import Foundation

struct TransparentAccount: Identifiable, Codable {
    var id: String { accountNumber }
    let accountNumber: String
    let bankCode: String
    let transparencyFrom: String?
    let transparencyTo: String?
    let publicationTo: String?
    let actualizationDate: String?
    let balance: Double?
    let currency: String?
    let name: String
    let description: String?
    let iban: String?
}

class NetworkManager: ObservableObject {
    @Published var accounts: [TransparentAccount] = []

    private let apiKey = Secrets.apiKey // Načtení z .env

    func fetchAccounts() {
        guard let url = URL(string: "https://webapi.developers.erstegroup.com/api/csas/sandbox/v3/transparentAccounts") else {
            print("Neplatná URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "web-api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Chyba requestu: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Žádná data")
                return
            }

            print(String(data: data, encoding: .utf8) ?? "Nelze dekódovat JSON na String")

            do {
                let decoded = try JSONDecoder().decode(ResponseWrapper.self, from: data)
                DispatchQueue.main.async {
                    self.accounts = decoded.accounts
                }
            } catch {
                print("Chyba dekódování: \(error)")
            }
        }.resume()
    }

    private struct ResponseWrapper: Codable {
        let accounts: [TransparentAccount]
    }
}
