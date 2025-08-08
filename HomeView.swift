import SwiftUI
import Foundation
import Lottie

// MARK: - Theme Extension
extension Color {
    static let themePurple = Color(red: 142/255, green: 124/255, blue: 255/255)
}

// MARK: - HomeView
struct HomeView: View {
    let userID: Int
    let username: String
    //    @State private var progress = ProgressModel()
    
    @ObservedObject private var appState = AppState.shared
    @State private var user: User?
    @State private var progress: ProgressData?
    @State private var course: Course?
    @State private var activeWeek: Int?
    @State private var progressError: String? = nil
    
    
    
    
    @State private var navigateToQuiz = false
    
    @State private var isSidebarOpen = false
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    @State private var isLoggedOut = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color(.systemGray6)]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            if isSidebarOpen {
                Color.black.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isSidebarOpen = false
                        }
                    }
            }
            
            SidebarView(isSidebarOpen: $isSidebarOpen, user: user, onLogout: {
                isLoggedOut = true
            })
            .zIndex(1)
            
            VStack(alignment: .leading, spacing: 20) {
                topBar
                content
            }
            .padding(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .disabled(isSidebarOpen)
            .blur(radius: isSidebarOpen ? 4 : 0)
            .animation(.easeInOut, value: isSidebarOpen)
        }
        .onAppear {
            navigateToQuiz = false      // ✅ Add this line
            loadUserData()              // Already there
            
        }
        
        .onReceive(appState.$profileUpdated) { updated in
            if updated {
                loadUserData()
                appState.profileUpdated = false
            }
        }
        
        .fullScreenCover(isPresented: $isLoggedOut) {
            IntroductionView()
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Button(action: {
                withAnimation(.spring()) {
                    isSidebarOpen.toggle()
                }
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.themePurple)
                    .padding(8)
                    .background(Color.themePurple.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
            
            let rawPic = user?.profile_pic ?? "/default-profile.png"
            let profilePicURL = (rawPic.hasPrefix("http://") || rawPic.hasPrefix("https://"))
            ? rawPic
            : "http://localhost/skillnity\(rawPic)"
            
            UserProfileImage(imageUrl: profilePicURL)
            
                .shadow(radius: 4)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    // MARK: - Main Content
    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .themePurple))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let error = errorMessage {
            ErrorView(message: error)
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if let user = user {
                        WelcomeSection(username: user.username, collegeName: user.college_name)
                    }
                    
                    
                    if let progress = progress {
                        ProgressSection(progress: progress)
                    }
                    
                    if let progress = progress {
                        ForEach(1...5, id: \.self) { week in
                            if week <= progress.week {
                                CourseCard(
                                    course: Course(
                                        title: "DSA Week \(week)",
                                        description: "Learn key concepts and solve quiz for Week \(week).",
                                        week: week
                                    ),
                                    userID: userID,
                                    navigateToQuiz: Binding(
                                        get: { activeWeek == week },
                                        set: { newValue in
                                            if newValue { activeWeek = week } else { activeWeek = nil }
                                        }
                                    )
                                    
                                )
                            } else {
                                LockedCourseCard(week: week)
                            }
                        }
                    }
                    
                    
                }
                
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
            .transition(.opacity)
            .animation(.easeInOut, value: progress != nil)
        }
            
        
    }



    // MARK: - Data Loading
    private func loadUserData() {
        isLoading = true
        APIService.shared.fetchUser(userID: userID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedUser):
                    self.user = fetchedUser
                    self.loadProgressData()
                case .failure(let error):
                    self.errorMessage = "User Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

//    private func loadProgressData() {
//        APIService.shared.fetchProgress(userID: userID) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let fetchedProgress):
//                    self.progress = fetchedProgress
//                    self.loadCourseData(week: fetchedProgress.week)
//                case .failure(let error):
//                    self.errorMessage = "Progress Error: \(error.localizedDescription)"
//                    self.isLoading = false
//                }
//            }
//        }
//    }
//    private func loadProgressData() {
//        APIService.shared.fetchProgress(userID: userID) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let fetchedProgress):
//                    self.progress = fetchedProgress
//
//                    // Safely convert week (String) to Int
//                    if let weekInt = Int(fetchedProgress.week) {
//                        self.loadCourseData(week: weekInt) // ✅ Correct usage
//                    } else {
//                        self.errorMessage = "Progress Error: Invalid week value"
//                        self.isLoading = false
//                    }
//
//                case .failure(let error):
//                    self.errorMessage = "Progress Error: \(error.localizedDescription)"
//                    self.isLoading = false
//                }
//            }
//        }
//    }
//    private func loadProgressData() {
//        APIService.shared.fetchProgress(userID: userID) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let fetchedProgress):
//                    self.progress = fetchedProgress
//                    self.loadCourseData(week: fetchedProgress.week) // ✅ Already Int
//                case .failure(let error):
//                    self.errorMessage = "Progress Error: \(error.localizedDescription)"
//                    self.isLoading = false
//                }
//            }
//        }
//    }
    private func loadProgressData() {
        APIService.shared.fetchProgress(userID: userID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedProgress):
                    self.progress = fetchedProgress
                    self.loadCourseData(week: fetchedProgress.week)
                case .failure(let error):
//                    self.errorMessage = "Progress Error: \(error.localizedDescription)"
                    self.errorMessage = "Progress Error: \(error.localizedDescription)\nCheck field names and types in ProgressData"

                    self.isLoading = false
                }
            }
        }
    }





    private func loadCourseData(week: Int) {
        APIService.shared.fetchCurrentCourse(week: week) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCourse):
                    self.course = fetchedCourse
                case .failure(let error):
                    self.errorMessage = "Course Error: \(error.localizedDescription)"
                }
                self.isLoading = false
            }
        }
    }

    

}



// MARK: - Welcome Section
struct WelcomeSection: View {
    let username: String
    let collegeName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Hi, \(username)!")
                .font(.largeTitle)
                .bold()

            Text("B.Tech Computer Science")
                .font(.subheadline)
                .foregroundColor(.gray)

            if let collegeName = collegeName {
                Text(collegeName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}


// MARK: - Progress Section
struct ProgressSection: View {
    let progress: ProgressData

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Learning Progress")
                .font(.title3)
                .bold()

            HStack {
                CircularProgressView(progress: progress.overallProgress)
                    .frame(width: 80, height: 80)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "rosette")
                            .foregroundColor(.themePurple)
                        Text("Badges Earned")
                        Spacer()
                        Text("\(progress.badges_earned)/5").bold()
                    }
                    HStack {
                        Image(systemName: "checkmark.seal")
                            .foregroundColor(.themePurple)
                        Text("Quizzes Passed")
                        Spacer()
                        Text("\(progress.quizzes_passed)/5").bold()
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5))
    }
}

//extension Progress {
//    var overallProgress: Double {
//        var overallProgress: Double {
//            guard progress.week > 0 else { return 0.0 }
//            
//            let badgeScore = Double(progress.badges_earned) / Double(progress.week)
//            let quizScore = Double(progress.quizzes_passed) / Double(progress.week)
//            let average = (badgeScore + quizScore) / 2.0
//            let overall = min(1.0, average)
//            
//            return overall
//        }
//
//        
//    }
//}
//extension ProgressData {
//    var overallProgress: Double {
//        guard let badges = Int(badges_earned),
//              let quizzes = Int(quizzes_passed),
//              week > 0 else {
//            return 0.0
//        }
//
//        let badgeScore = Double(badges) / Double(week)
//        let quizScore = Double(quizzes) / Double(week)
//        let average = (badgeScore + quizScore) / 2.0
//        return min(1.0, average)
//    }
//}

//var overallProgress: Double {
//    guard progress.week > 0 else { return 0.0 }
//    
//    let badgeScore = Double(progress.badges_earned) / Double(progress.week)
//    let quizScore = Double(progress.quizzes_passed) / Double(progress.week)
//    let average = (badgeScore + quizScore) / 2.0
//    let overall = min(1.0, average)
//    
//    return overall
//}


// MARK: - Course Card
struct CourseCard: View {
    let course: Course
    let userID: Int
    @Binding var navigateToQuiz: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(course.title)
                    .font(.headline)
                    .bold()
                Spacer()
                Image(systemName: "book.fill")
                    .foregroundColor(.themePurple)
            }

            Text(course.description)
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.themePurple)
                Text("Week \(course.week)")
                    .font(.subheadline)
                    .foregroundColor(.themePurple)
                Spacer()

                NavigationLink(
                    destination: DSAWeekView(week: course.week, userID: userID),
                    isActive: $navigateToQuiz
                ) {
                    Button(action: {
                        navigateToQuiz = true
                    }) {
                        Text("Start")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.themePurple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

struct LockedCourseCard: View {
    let week: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("DSA Week \(week)")
                    .font(.headline)
                    .bold()
                Spacer()
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
            }

            Text("Complete Week \(week - 1) to unlock this.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - User Profile Image
struct UserProfileImage: View {
    let imageUrl: String

    var body: some View {
        if let url = URL(string: imageUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView().frame(width: 40, height: 40)
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure(_):
                    Image("default-profile").resizable().aspectRatio(contentMode: .fill)
                @unknown default:
                    Image("default-profile").resizable().aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
        } else {
            Image("default-profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
    }
}

// MARK: - Circular Progress View
struct CircularProgressView: View {
    var progress: Double
    var lineWidth: CGFloat = 10
    var size: CGFloat = 80
    var progressColor: Color = .themePurple
    var backgroundColor: Color = Color(.systemGray5)

    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(progressColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            Text("\(Int(progress * 100))%")
                .font(.headline)
                .bold()
                .foregroundColor(progressColor)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text(message)
                .font(.body)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct DSAWeekView: View {
    let week: Int
    let userID: Int

    var body: some View {
        switch week {
        case 1: DSAWeek1View(userID: userID)
        case 2: DSAWeek2View(userID: userID)
        case 3: DSAWeek3View(userID: userID)
        case 4: DSAWeek4View(userID: userID)
        case 5: DSAWeek5View(userID: userID)
        default: Text("Invalid Week")
        }
    }
}

// MARK: - Preview
struct HomeView_preview: PreviewProvider {
    static var previews: some View {
        HomeView(userID: 1, username: "Rohith")
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.themePurple)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: Color.themePurple.opacity(configuration.isPressed ? 0.7 : 0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

