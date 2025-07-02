import SwiftUI

struct AppLoadingView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                VStack {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                        .padding(.bottom, 8)

                    Text("Účty se načítají...")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.ignoresSafeArea())
            } else {
                ContentView()
                    .environmentObject(networkManager)
            }
        }
        .onAppear {
            networkManager.fetchAccounts {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    AppLoadingView()
}
