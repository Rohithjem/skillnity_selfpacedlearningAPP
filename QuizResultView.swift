import SwiftUI

struct QuizResultView: View {
    let score: Int
    let total: Int
    @State private var goHome = false

    var body: some View {
        VStack(spacing: 20) {
            LottieView(animationName: "trophy_confetti", loopMode: .loop)
                .frame(height: 200)

            Text("🎉 Great job!")
                .font(.title)
                .foregroundColor(.themePurple)

            Text("You scored \(score) out of \(total * 10)")
                .font(.headline)

            Button("Back to Home") {
                goHome = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.themePurple)
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .padding()
        .navigationBarBackButtonHidden(true)

        // ✅ Go to HomeView as full screen
        .fullScreenCover(isPresented: $goHome) {
            NavigationStack {
                HomeView(userID: AppState.shared.userID ?? 0,
                         username: AppState.shared.username ?? "User")
            }
        }
    }
}
