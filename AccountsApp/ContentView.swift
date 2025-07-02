import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var searchText = ""

    var filteredAccounts: [TransparentAccount] {
        if searchText.isEmpty {
            return networkManager.accounts
        } else {
            return networkManager.accounts.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Hledat podle názvu účtu...", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .submitLabel(.done) // lepší UX
                }

                Section {
                    if filteredAccounts.isEmpty {
                        Text("Nenalezen žádný účet.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filteredAccounts) { account in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(account.name)
                                    .font(.headline)
                                    .foregroundColor(.blue)

                                Text("Účet: \(account.accountNumber)/\(account.bankCode)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                if let balance = account.balance, let currency = account.currency {
                                    Text("Zůstatek: \(balance, specifier: "%.2f") \(currency)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Transparentní účty")
            .onAppear {
                networkManager.fetchAccounts()
            }
        }
    }
}

#Preview {
    ContentView()
}
