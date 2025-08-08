import SwiftUI

struct LeaderboardView: View {
    @State private var users: [LeaderboardUser] = []
    @State private var selectedTab = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.themePurple)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }

                    Spacer()
                    Text("Leaderboard 👑")
                        .font(.title2).bold()
                    Spacer()
                    Color.clear.frame(width: 36) // To balance the back button
                }
                .padding(.horizontal)

                // Tabs
                HStack(spacing: 0) {
                    ForEach(["All Time 🥇", "This Week 🎯"].indices, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selectedTab = index
                            }
                        }) {
                            Text(["All Time 🥇", "This Week 🎯"][index])
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedTab == index ? Color.themePurple.opacity(0.2) : Color.clear)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(4)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
                .padding(.horizontal)

                // Top 3
                if users.count >= 3 {
                    HStack(alignment: .bottom) {
                        ForEach(Array(users.prefix(3).enumerated()), id: \.offset) { index, user in
                            VStack(spacing: 6) {
                                AsyncImage(url: URL(string: user.profile_pic ?? "")) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(
                                        index == 0 ? Color.yellow :
                                        index == 1 ? Color.gray :
                                        Color.brown,
                                        lineWidth: 3
                                    )
                                )
                                Text(user.username)
                                    .font(.caption)
                                    .bold()
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }

                // Top 10 List
                VStack(spacing: 12) {
                    ForEach(users.indices, id: \.self) { index in
                        let user = users[index]

                        HStack(spacing: 12) {
                            Text("\(index + 1)")
                                .font(.headline)
                                .frame(width: 30)

                            AsyncImage(url: URL(string: user.profile_pic ?? "")) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable().scaledToFit()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text(user.username)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(user.college)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Text("\(user.badges) pts")
                                .font(.headline)
                                .foregroundColor(.themePurple)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .cornerRadius(12)
                        .background(user.id == AppState.shared.userID ? Color.themePurple.opacity(0.05) : Color.white)
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(user.id == AppState.shared.userID ? Color.themePurple.opacity(0.3) : .clear, lineWidth: 1)
                        )

                        .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                        .animation(.easeInOut(duration: 0.2), value: users)
                    }
                }
                .padding(.horizontal)
            }

            Spacer(minLength: 20)

            Text("Keep learning. Keep leading.\nSkillnity rewards growth!")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
        .onAppear {
            fetchLeaderboard()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .background(Color.white.ignoresSafeArea())
    }

    func fetchLeaderboard() {
        guard let url = URL(string: "http://localhost/skillnity/get_leaderboard.php") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode([LeaderboardUser].self, from: data)
                    DispatchQueue.main.async {
                        self.users = decoded
                    }
                } catch {
                    print("❌ Decode error: \(error.localizedDescription)")
                    print("🔵 Raw JSON: \(String(data: data, encoding: .utf8) ?? "Unreadable")")
                }
            } else {
                print("❌ No data received from leaderboard endpoint")
            }
        }.resume()
    }
}

struct LeaderboardUser: Codable, Identifiable, Equatable {
    let id: Int
    let username: String
    let college: String
    let profile_pic: String?
    let badges: Int
}
