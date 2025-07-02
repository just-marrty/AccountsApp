import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State private var searchText = ""
    @State private var selectedAccount: TransparentAccount?

    var filteredAccounts: [TransparentAccount] {
        let cleanedAccounts = networkManager.accounts.map { account in
            TransparentAccount(
                accountNumber: account.accountNumber,
                bankCode: account.bankCode,
                transparencyFrom: account.transparencyFrom,
                transparencyTo: account.transparencyTo,
                publicationTo: account.publicationTo,
                actualizationDate: account.actualizationDate,
                balance: account.balance,
                currency: account.currency,
                name: account.name.trimmingCharacters(in: .whitespacesAndNewlines),
                description: account.description,
                iban: account.iban
            )
        }

        let sorted = cleanedAccounts.sorted { lhs, rhs in
            let lhsName = lhs.name
            let rhsName = rhs.name

            let lhsIsNumber = lhsName.first?.isNumber ?? false
            let rhsIsNumber = rhsName.first?.isNumber ?? false

            // Mezera na konec
            let lhsStartsWithSpace = lhsName.hasPrefix(" ")
            let rhsStartsWithSpace = rhsName.hasPrefix(" ")

            if lhsStartsWithSpace != rhsStartsWithSpace {
                return !lhsStartsWithSpace
            }

            // Čísla na konec
            if lhsIsNumber != rhsIsNumber {
                return !lhsIsNumber
            }

            return lhsName.localizedCompare(rhsName) == .orderedAscending
        }

        if searchText.isEmpty {
            return sorted
        } else {
            return sorted.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                
                // ZStack pro TextField a křížek
                ZStack {
                    TextField("Hledat podle názvu účtu...", text: $searchText)
                        .padding(.leading, 16)
                        .padding(.trailing, 36)
                        .frame(height: 50)
                        .font(.system(size: 18))
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .submitLabel(.done)
                        .onSubmit {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }

                    if !searchText.isEmpty {
                        HStack {
                            Spacer()
                            Button(action: {
                                searchText = ""
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .frame(width: 24, height: 24)
                            }
                            .padding(.trailing, 12)
                        }
                        .frame(height: 50)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)

                List {
                    if filteredAccounts.isEmpty {
                        Text("Nenalezen žádný účet.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filteredAccounts) { account in
                            NavigationLink(value: account) {
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
                .listStyle(.plain)
                .refreshable {
                    networkManager.fetchAccounts()
                }
                Spacer().frame(height: 4)
            }
            .navigationTitle("Transparentní účty ČS")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: TransparentAccount.self) { account in
                AccountDetailView(account: account)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NetworkManager())
}
