import SwiftUI

struct AccountDetailView: View {
    let account: TransparentAccount

    var body: some View {
        Form {
            Section(header: Text("Název účtu")) {
                Text(account.name)
            }

            Section(header: Text("Číslo účtu")) {
                Text("\(account.accountNumber)/\(account.bankCode)")
            }

            if let balance = account.balance, let currency = account.currency {
                Section(header: Text("Zůstatek")) {
                    Text("\(balance, specifier: "%.2f") \(currency)")
                }
            }

            if let iban = account.iban {
                Section(header: Text("IBAN")) {
                    Text(iban)
                }
            }

            if let description = account.description {
                Section(header: Text("Popis")) {
                    Text(description)
                }
            }

            if let transparencyFrom = account.transparencyFrom {
                Section(header: Text("Transparentní od")) {
                    Text(transparencyFrom)
                }
            }

            if let actualizationDate = account.actualizationDate {
                Section(header: Text("Aktualizováno")) {
                    Text(actualizationDate)
                }
            }
        }
        .navigationTitle("Detail účtu")
    }
}

#Preview {
    let mockAccount = TransparentAccount(
        accountNumber: "123456789",
        bankCode: "0800",
        transparencyFrom: "2020-01-01",
        transparencyTo: nil,
        publicationTo: nil,
        actualizationDate: "2024-07-01",
        balance: 15000.75,
        currency: "CZK",
        name: "Česká spořitelna, nadační fond",
        description: "Testovací účet pro náhled",
        iban: "CZ6508000000001234567899"
    )

    return NavigationStack {
        AccountDetailView(account: mockAccount)
            .navigationTitle("Detail účtu")
            .navigationBarTitleDisplayMode(.inline)
    }
}


