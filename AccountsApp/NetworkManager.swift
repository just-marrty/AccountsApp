import Foundation

struct TransparentAccount: Identifiable, Codable, Hashable {
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
    @Published var isLoading = true
    @Published var error: String?

    private let apiKey = Secrets.apiKey

    init() {
        // Automaticky začít načítat data při inicializaci
        fetchAccounts()
    }

    func fetchAccounts(completion: (() -> Void)? = nil) {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://webapi.developers.erstegroup.com/api/csas/sandbox/v3/transparentAccounts") else {
            print("Neplatná URL")
            error = "Neplatná URL"
            isLoading = false
            completion?()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "web-api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                defer {
                    self.isLoading = false
                    completion?()
                }

                if let error = error {
                    print("Chyba requestu: \(error.localizedDescription)")
                    self.error = error.localizedDescription
                    return
                }

                guard let data = data else {
                    print("Žádná data")
                    self.error = "Žádná data nebyla přijata"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(ResponseWrapper.self, from: data)
                    self.accounts = decoded.accounts
                } catch {
                    print("Chyba dekódování: \(error)")
                    print(String(data: data, encoding: .utf8) ?? "Nešlo převést na text")
                    self.error = "Chyba při zpracování dat"
                }
            }
        }.resume()
    }

    private struct ResponseWrapper: Codable {
        let accounts: [TransparentAccount]
    }
}
