import SwiftUI

struct SidebarView: View {
    @Binding var isSidebarOpen: Bool
    let user: User?
    let onLogout: () -> Void // <-- Added logout handler

    var body: some View {
        ZStack(alignment: .leading) {
            if isSidebarOpen {
                Color.black.opacity(0.11)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isSidebarOpen = false
                        }
                    }
                    .transition(.opacity)
            }

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Skillnity")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.themePurple)

                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isSidebarOpen = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal)

                Divider().padding(.horizontal)

                if let user = user {
                    HStack(spacing: 12) {
                        let rawPic = user.profile_pic ?? "/default-profile.png"
                        let profilePicURL = (rawPic.hasPrefix("http://") || rawPic.hasPrefix("https://"))
                            ? rawPic
                            : "http://localhost/skillnity\(rawPic)"

                        UserProfileImage(imageUrl: profilePicURL)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())


                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.username)
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(user.college_name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                }

                Divider().padding(.horizontal)

                VStack(alignment: .leading, spacing: 20) {
                    if let user = user {
                        SidebarLink(title: "Profile", icon: "person.crop.circle") {
                            ProfileView(userID: user.id)
                        }
                    }
                    
                    SidebarLink(title: "Roadmap", icon: "map.fill") {
                        RoadmapSelectionView()
                    }
                    
                    SidebarLink(title: "Resume Projects", icon: "folder.fill") {
                        ResumeProjectsView()                    }
                    
                    SidebarLink(title: "Coding Battles", icon: "bolt.fill") {
                        CodingBattleView()
                    }
                    
                    SidebarLink(title: "Leaderboard", icon: "trophy.fill") {
                        LeaderboardView()
                    }
                    
                    SidebarLink(title: "AI Milo", icon: "mic.fill") {
                        AInterviewView()
                    }
                    
                    Spacer()
                    
                    // MARK: Logout Button
                    //                    Button(action: {
                    //                        onLogout() // <-- triggers fullScreenCover logout
                    //                    }) {
                    //                        SidebarMenuItem(icon: "rectangle.portrait.and.arrow.right", title: "Logout")
                    //                    }
                    //                }
                    Button(action: {
                        AppState.shared.logout()
                    }) {
                        SidebarMenuItem(icon: "rectangle.portrait.and.arrow.right", title: "Logout")
                    }
                }

                .padding(.horizontal)
                .padding(.top, 10)

                Spacer()
            }
            .frame(width: 260)
            .padding(.vertical)
            .background(BlurView(style: .systemUltraThinMaterial))
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            .offset(x: isSidebarOpen ? 0 : -300)
            .animation(.easeInOut(duration: 0.5), value: isSidebarOpen)
        }
    }
}

// MARK: - Menu Item
struct SidebarMenuItem: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.themePurple)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.themePurple.opacity(0.05))
        .cornerRadius(10)
    }
}

// MARK: - SidebarLink
struct SidebarLink<Destination: View>: View {
    let title: String
    let icon: String
    let destination: Destination

    @State private var isPresented = false

    init(title: String, icon: String, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.icon = icon
        self.destination = destination()
    }

    var body: some View {
        Button(action: {
            isPresented = true
        }) {
            SidebarMenuItem(icon: icon, title: title)
        }
        .background(
            NavigationLink(destination: destination, isActive: $isPresented) {
                EmptyView()
            }
            .hidden()
        )
    }
}

// MARK: - Blur View
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
