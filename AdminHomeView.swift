//
//  AdminHomeView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 28/07/25.
//

import Foundation
import SwiftUI


struct AdminHomeView: View {
    @StateObject private var appState = AppState.shared
    @State private var user: AdminUser? = nil
    @State private var isLoadingAdmin = true
    @State private var fetchError: String?
    @State private var recentActivities: [AdminActivity] = []
    @State private var isLoadingActivities = true
    @State private var activityError: String?
    @State private var adminActivities: [AdminActivity] = []
    


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection

                    if isLoadingAdmin {
                        HStack(spacing: 8) {
                            ProgressView()
                            Text("Fetching admin profile...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    } else if let fetchError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                            VStack(alignment: .leading) {
                                Text("Failed to load admin profile")
                                    .fontWeight(.semibold)
                                Text(fetchError)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button("Retry") {
                                loadAdmin()
                            }
                            .font(.caption)
                            .padding(6)
                            .background(Color.themePurple.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }

                    quickStatsSection

                    recentActivitySection

                    logoutButton
                }
                .padding(.bottom, 10)
            }
            .onAppear {
                loadAdmin()
                loadActivities()
                
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Text("Welcome, \(appState.username.capitalized)")
                .font(.system(size: 22, weight: .bold))
            Spacer()
            let rawPic = user?.profile_pic ?? "/default-profile.png"
            let profilePicURL = (rawPic.hasPrefix("http://") || rawPic.hasPrefix("https://")) ? rawPic : "http://localhost/skillnity\(rawPic)"
            AdminProfileImage(imageUrl: profilePicURL)
                .shadow(radius: 4)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
//    private func loadAdmin() {
//        isLoadingAdmin = true
//        fetchError = nil
//
//        APIService.shared.fetchAdminUser(userID: appState.userID) { result in
//            DispatchQueue.main.async {
//                isLoadingAdmin = false
//                switch result {
//                case .success(let admin):
//                    self.user = admin
//                    loadActivities() // 👈 Load after admin
//                case .failure(let err):
//                    self.fetchError = err.localizedDescription
//                }
//            }
//        }
//    }
//    private var recentActivitySection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Recent Activity")
//                .font(.system(size: 18, weight: .semibold))
//                .padding(.bottom, 5)
//
//            if adminActivities.isEmpty {
//                Text("No recent activity.")
//                    .foregroundColor(.gray)
//                    .font(.caption)
//            } else {
//                ForEach(adminActivities) { activity in
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text(activity.title)
//                            .font(.system(size: 16, weight: .semibold))
//                            .foregroundColor(.black)
//
//                        Text(activity.description)
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//
//                        Text(activity.timestamp)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//                }
//            }
//        }
//        .padding(.horizontal)
//    }


//    private func loadActivities() {
////        APIService.shared.fetchAdminActivities { result in
////            DispatchQueue.main.async {
////                switch result {
////                case .success(let activities):
////                    self.adminActivities = activities
////                case .failure(_):
////                    self.adminActivities = []
////                }
////            }
////        }
//        APIService.shared.fetchAdminActivities { result in
//            switch result {
//            case .success(let activities):
//                self.recentActivities = activities
//            case .failure(let error):
//                self.activityError = error.localizedDescription
//            }
//            self.isLoadingActivities = false
//        }
//
//    }
    func loadActivities() {
            isLoadingActivities = true
        APIService.shared.fetchAdminActivities { result in
            switch result {
            case .success(let activities):
                self.recentActivities = activities
            case .failure(let error):
                self.activityError = error.localizedDescription
            }
            self.isLoadingActivities = false
        }

        }
    private func loadAdmin() {
        isLoadingAdmin = true
        fetchError = nil
        APIService.shared.fetchAdminUser(userID: appState.userID) { result in
            DispatchQueue.main.async {
                isLoadingAdmin = false
                switch result {
                case .success(let admin):
                    self.user = admin
                case .failure(let err):
                    self.fetchError = err.localizedDescription
                }
            }
        }
    }



    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Stats")
                .font(.system(size: 18, weight: .semibold))
                .padding(.bottom, 5)

            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                AdminCardView(
                    title: "Manage Courses",
                    subtitle: "Add, update,\ndelete courses",
                    icon: "doc.plaintext",
                    color: "#796EF3"
                ) {
                    AdminCourseListView()
                }

                AdminCardView(
                    title: "Student Progress",
                    subtitle: "View leaderboard\n& results",
                    icon: "chart.bar",
                    color: "#796EF3"
                ) {
                    LeaderboardView()
                }

                AdminCardView(
                    title: "Resume Projects",
                    subtitle: "Manage project\nideas",
                    icon: "graduationcap.fill",
                    color: "#796EF3"
                ) {
                    AdminResumeProjectsView()
                }

                if let user {
                    AdminCardView(
                        title: "Settings",
                        subtitle: "App settings...",
                        icon: "gearshape.fill",
                        color: "#796EF3"
                    ) {
                        AdminSettingsView(userID: user.id)
                    }
                } else if isLoadingAdmin {
                    AdminCardView(
                        title: "Settings",
                        subtitle: "Loading...",
                        icon: "gearshape.fill",
                        color: "#CCCCCC"
                    ) {
                        EmptyView()
                    }
                    .disabled(true)
                } else {
                    AdminCardView(
                        title: "Settings",
                        subtitle: "Unavailable",
                        icon: "gearshape.fill",
                        color: "#CCCCCC"
                    ) {
                        EmptyView()
                    }
                    .disabled(true)
                }
            }
            .padding()
            .background(Color(hex: "#F6F7FB"))
            .cornerRadius(20)
            .padding(.horizontal)
        }
    }

//    private var recentActivitySection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Recent Activity")
//                .font(.system(size: 18, weight: .semibold))
//                .padding(.bottom, 5)
//
//            if isLoadingActivities {
//                ProgressView("Loading recent activities...")
//                    .padding()
//            } else if let activityError {
//                Text("Error: \(activityError)")
//                    .foregroundColor(.red)
//                    .padding()
//            } else {
//                ForEach(recentActivities) { activity in
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text(activity.title)
//                            .font(.system(size: 16, weight: .semibold))
//                            .foregroundColor(.black)
//
//                        Text(activity.description) // ✅ changed from subtitle
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//
//                        Text(activity.timestamp)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//                }
//            }
//        }
//        .padding(.horizontal)
//    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Activity")
                .font(.system(size: 18, weight: .semibold))
                .padding(.bottom, 5)

            if isLoadingActivities {
                ProgressView("Loading recent activities...")
                    .padding()
            } else if let activityError {
                Text("Error: \(activityError)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Scrollable box with a fixed height and only the latest 10
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 12) {
                        ForEach(recentActivities.prefix(10)) { activity in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(activity.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)

                                Text(activity.description)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)

                                Text(activity.timestamp)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(height: 260) // ⬅️ Adjust height as needed
                .padding(.horizontal, 2)
            }
        }
        .padding(.horizontal)
    }

    




    private var logoutButton: some View {
        Button {
            appState.logout()
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Logout")
            }
            .foregroundColor(.red)
            .fontWeight(.semibold)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .navigationBarBackButtonHidden(true)
    }

    
}

//struct AdminHomeView: View {
//    @StateObject private var appState = AppState.shared
//    @State private var user: AdminUser? = nil
//    @State private var isLoadingAdmin = true
//    @State private var fetchError: String?
//
//    // Dummy quick stats (replace with dynamic fetch if needed)
//    @State private var activeStudents = "2,845"
//    @State private var totalCourses = "124"
//    @State private var totalProjects = "38"
//    @State private var totalCertificates = "1,234"
//
//    let recentActivity = [
//        ("New Course Added", "Advanced React Patterns", "2 hours ago"),
//        ("Certificate Issued", "UI/UX Design Fundamentals", "4 hours ago"),
//        ("Project Updated", "E-commerce Dashboard", "6 hours ago")
//    ]
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                    headerSection
//
//                    if isLoadingAdmin {
//                        // show inline loading indicator so user sees profile is fetching
//                        HStack(spacing: 8) {
//                            ProgressView()
//                            Text("Fetching admin profile...")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        .padding(.horizontal)
//                    } else if let fetchError {
//                        HStack {
//                            Image(systemName: "exclamationmark.triangle.fill")
//                                .foregroundColor(.yellow)
//                            VStack(alignment: .leading) {
//                                Text("Failed to load admin profile")
//                                    .fontWeight(.semibold)
//                                Text(fetchError)
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            Spacer()
//                            Button("Retry") {
//                                loadAdmin()
//                            }
//                            .font(.caption)
//                            .padding(6)
//                            .background(Color.themePurple.opacity(0.1))
//                            .cornerRadius(8)
//                        }
//                        .padding(.horizontal)
//                    }
//
//                    quickStatsSection
//
//                    recentActivitySection
//
//                    logoutButton
//                }
//                .padding(.bottom, 10)
//            }
//            .onAppear {
//                loadAdmin()
//            }
//        }
//    }
//
//    // MARK: - Subviews
//
//    private var headerSection: some View {
//        HStack {
//            Text("Welcome, \(appState.username.capitalized)")
//                .font(.system(size: 22, weight: .bold))
//            Spacer()
//            let rawPic = user?.profile_pic ?? "/default-profile.png"
//            let profilePicURL = (rawPic.hasPrefix("http://") || rawPic.hasPrefix("https://")) ? rawPic : "http://localhost/skillnity\(rawPic)"
//            AdminProfileImage(imageUrl: profilePicURL)
//                .shadow(radius: 4)
//                .frame(width: 40, height: 40)
//                .clipShape(Circle())
//        }
//        .padding(.horizontal)
//        .padding(.top, 20)
//    }
//
//    private var quickStatsSection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Quick Stats")
//                .font(.system(size: 18, weight: .semibold))
//                .padding(.bottom, 5)
//
//            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
//                AdminCardView(
//                    title: "Manage Courses",
//                    subtitle: "Add, update,\ndelete courses",
//                    icon: "doc.plaintext",
//                    color: "#796EF3"
//                ) {
//                    AdminCourseListView()
//                }
//
//                AdminCardView(
//                    title: "Student Progress",
//                    subtitle: "View leaderboard\n& results",
//                    icon: "chart.bar",
//                    color: "#796EF3"
//                ) {
//                    StudentProgressView()
//                }
//
//                AdminCardView(
//                    title: "Resume Projects",
//                    subtitle: "Manage project\nideas",
//                    icon: "graduationcap.fill",
//                    color: "#796EF3"
//                ) {
//                    ResumeProjectsView()
//                }
//
//                // Settings card: only active when user is loaded successfully
//                if let user {
//                    AdminCardView(
//                        title: "Settings",
//                        subtitle: "App settings...",
//                        icon: "gearshape.fill",
//                        color: "#796EF3"
//                    ) {
//                        AdminSettingsView(userID: user.id)
//                    }
//                } else if isLoadingAdmin {
//                    AdminCardView(
//                        title: "Settings",
//                        subtitle: "Loading...",
//                        icon: "gearshape.fill",
//                        color: "#CCCCCC"
//                    ) {
//                        EmptyView()
//                    }
//                    .disabled(true)
//                } else {
//                    // failed earlier: allow retry or keep disabled
//                    AdminCardView(
//                        title: "Settings",
//                        subtitle: "Unavailable",
//                        icon: "gearshape.fill",
//                        color: "#CCCCCC"
//                    ) {
//                        EmptyView()
//                    }
//                    .disabled(true)
//                }
//            }
//            .padding()
//            .background(Color(hex: "#F6F7FB"))
//            .cornerRadius(20)
//            .padding(.horizontal)
//        }
//    }
//
//    private var recentActivitySection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Recent Activity")
//                .font(.system(size: 18, weight: .semibold))
//                .padding(.bottom, 5)
//
//            ForEach(recentActivity, id: \.0) { activity in
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(activity.0)
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(.black)
//                    Text(activity.1)
//                        .font(.system(size: 14))
//                        .foregroundColor(.gray)
//                    Text(activity.2)
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(12)
//                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//            }
//        }
//        .padding(.horizontal)
//    }
//
//    private var logoutButton: some View {
//        Button {
//            appState.logout()
//        } label: {
//            HStack {
//                Image(systemName: "rectangle.portrait.and.arrow.right")
//                Text("Logout")
//            }
//            .foregroundColor(.red)
//            .fontWeight(.semibold)
//            .padding(.vertical, 12)
//            .frame(maxWidth: .infinity)
//        }
//        .padding(.horizontal)
//        .padding(.bottom, 20)
//        .navigationBarBackButtonHidden(true)
//    }
//
//    // MARK: - Loading
//
//    private func loadAdmin() {
//        isLoadingAdmin = true
//        fetchError = nil
//        APIService.shared.fetchadmin(userID: appState.userID) { result in
//            DispatchQueue.main.async {
//                isLoadingAdmin = false
//                switch result {
//                case .success(let fetchedUser):
//                    self.user = fetchedUser
//                case .failure(let err):
//                    self.fetchError = err.localizedDescription
//                }
//            }
//        }
//    }
//}

//struct AdminHomeView: View {
////    let userID: Int
////    let username: String
//    let adminID: Int
//    let adminUsername: String
//    @State private var user: User?
////    @AppStorage("userID") var userID: Int = 0
////    @AppStorage("username") var username: String = ""
////    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true
//    @State private var isLoggedOut = false
//    // Simulated stats (replace with API data later)
//    @State private var activeStudents = "2,845"
//    @State private var totalCourses = "124"
//    @State private var totalProjects = "38"
//    @State private var totalCertificates = "1,234"
//    @ObservedObject var appState = AppState.shared
//   
//
////    @State private var isLoggedOut = false
//    
//
//
//
//    // Simulated recent activity
//    let recentActivity = [
//        ("New Course Added", "Advanced React Patterns", "2 hours ago"),
//        ("Certificate Issued", "UI/UX Design Fundamentals", "4 hours ago"),
//        ("Project Updated", "E-commerce Dashboard", "6 hours ago")
//    ]
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                    
//                    // MARK: - Header
//                    HStack {
//                        Text("Welcome, \(appState.username.capitalized)")
//
//                            .font(.system(size: 22, weight: .bold))
//                        Spacer()
//                        let rawPic = user?.profile_pic ?? "/default-profile.png"
//                                let profilePicURL = (rawPic.hasPrefix("http://") || rawPic.hasPrefix("https://"))
//                                    ? rawPic
//                                    : "http://localhost/skillnity\(rawPic)"
//
//                        AdminProfileImage(imageUrl: profilePicURL)
//
//                            .shadow(radius: 4)
////                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .clipShape(Circle())
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 20)
//
//                    // MARK: - Admin Options Grid
//                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
//                        AdminCardView(title: "Manage Courses", subtitle: "Add, update,\ndelete courses", icon: "doc.plaintext", color: "#796EF3")
//                        AdminCardView(title: "Student Progress", subtitle: "View leaderboard\n& results", icon: "chart.bar", color: "#796EF3")
//                        AdminCardView(title: "Resume Projects", subtitle: "Manage project\nideas", icon: "graduationcap.fill", color: "#796EF3")
//                        AdminCardView(title: "Settings", subtitle: "app settings...", icon: "gearshape.fill", color: "#796EF3")
//                    }
//                    .padding(.horizontal)
//
//                    // MARK: - Quick Stats
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Quick Stats")
//                            .font(.system(size: 18, weight: .semibold))
//                            .padding(.bottom, 5)
//
//                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
//                            StatBox(title: "Active Students", value: activeStudents)
//                            StatBox(title: "Total Courses", value: totalCourses)
//                            StatBox(title: "Projects", value: totalProjects)
//                            StatBox(title: "Certificates", value: totalCertificates)
//                        }
//                    }
//                    .padding()
//                    .background(Color(hex: "#F6F7FB"))
//                    .cornerRadius(20)
//                    .padding(.horizontal)
//
//                    // MARK: - Recent Activity
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Recent Activity")
//                            .font(.system(size: 18, weight: .semibold))
//                            .padding(.bottom, 5)
//
//                        ForEach(recentActivity, id: \.0) { activity in
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text(activity.0)
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.black)
//                                Text(activity.1)
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                Text(activity.2)
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(12)
//                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//                        }
//                    }
//                    .padding(.horizontal)
//
//                    // MARK: - Logout
////                    Button() {
////                        appState.logout()
////                    }
////                    {
////                        HStack {
////                            Image(systemName: "rectangle.portrait.and.arrow.right")
////                            Text("Logout")
////                        }
////                        .foregroundColor(.red)
////                        .fontWeight(.semibold)
////                        .padding(.vertical, 12)
////                        .frame(maxWidth: .infinity)
////                    }
//                    Button {
//                        appState.logout()
//                    } label: {
//                        HStack {
//                            Image(systemName: "rectangle.portrait.and.arrow.right")
//                            Text("Logout")
//                        }
//                        .foregroundColor(.red)
//                        .fontWeight(.semibold)
//                        .padding(.vertical, 12)
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    .padding(.horizontal)
//                    .padding(.bottom, 20)
////                    .fullScreenCover(isPresented: $isLoggedOut) {
////                                IntroductionView()
////                    }
//                    .navigationBarBackButtonHidden(true)
//                }
//            }
//        }
//    }
//}
//    @State var user: AdminUser?
//    @State private var user: AdminUser? = nil
//    @ObservedObject var appState = AppState.shared
//    @State private var user: User? = nil
//    let user: User?

//struct AdminHomeView: View {
//
//    @StateObject private var appState = AppState.shared
//
//
//    @State var user: User? = nil
//
//
//    @State private var activeStudents = "2,845"
//    @State private var totalCourses = "124"
//    @State private var totalProjects = "38"
//    @State private var totalCertificates = "1,234"
//    @State private var isLoadingAdmin = true
//    @State private var fetchError: String?
//
//    let recentActivity = [
//        ("New Course Added", "Advanced React Patterns", "2 hours ago"),
//        ("Certificate Issued", "UI/UX Design Fundamentals", "4 hours ago"),
//        ("Project Updated", "E-commerce Dashboard", "6 hours ago")
//    ]
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                    HStack {
//                        Text("Welcome, \(appState.username.capitalized)")
//                            .font(.system(size: 22, weight: .bold))
//                        Spacer()
//                        let rawPic = user?.profile_pic ?? "/default-profile.png"
//                        let profilePicURL = (rawPic.hasPrefix("http://") || rawPic.hasPrefix("https://")) ? rawPic : "http://localhost/skillnity\(rawPic)"
//                        AdminProfileImage(imageUrl: profilePicURL)
//                            .shadow(radius: 4)
//                            .frame(width: 40, height: 40)
//                            .clipShape(Circle())
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 20)
//
////                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
////                        AdminCardView(title: "Manage Courses", subtitle: "Add, update,\ndelete courses", icon: "doc.plaintext", color: "#796EF3")
////                        AdminCardView(title: "Student Progress", subtitle: "View leaderboard\n& results", icon: "chart.bar", color: "#796EF3")
////                        AdminCardView(title: "Resume Projects", subtitle: "Manage project\nideas", icon: "graduationcap.fill", color: "#796EF3")
////                        AdminCardView(title: "Settings", subtitle: "app settings...", icon: "gearshape.fill", color: "#796EF3")
////                    }
////                    .padding(.horizontal)
//
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Quick Stats")
//                            .font(.system(size: 18, weight: .semibold))
//                            .padding(.bottom, 5)
//
////                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
////                            StatBox(title: "Active Students", value: activeStudents)
////                            StatBox(title: "Total Courses", value: totalCourses)
////                            StatBox(title: "Projects", value: totalProjects)
////                            StatBox(title: "Certificates", value: totalCertificates)
////                        }
//                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
//                            AdminCardView(
//                                title: "Manage Courses",
//                                subtitle: "Add, update,\ndelete courses",
//                                icon: "doc.plaintext",
//                                color: "#796EF3"
//                            ) {
//                                AdminCourseListView()
//                            }
//                            
//
//
//                            AdminCardView(
//                                title: "Student Progress",
//                                subtitle: "View leaderboard\n& results",
//                                icon: "chart.bar",
//                                color: "#796EF3"
//                            ) {
//                                StudentProgressView()
//                            }
//                            AdminCardView(
//                                title: "Resume Projects",
//                                subtitle: "Manage project\nideas",
//                                icon: "graduationcap.fill",
//                                color: "#796EF3"
//                    
//                            ) {
//                                ResumeProjectsView()
//                            }
////                            AdminCardView(
////                                title: "Settings",
////                                subtitle: "App settings...",
////                                icon: "gearshape.fill",
////                                color: "#796EF3"
////                            ) {
////                                AdminSettingsView(userID: user.id)
////                            }
////                            AdminCardView(
////                                title: "Settings",
////                                subtitle: "App settings...",
////                                icon: "gearshape.fill",
////                                color: "#796EF3"
////                            ) {
////                                if let user = user {
////                                    Opensettings() {
////                                        AdminSettingsView(userID: user.id)
////                                    }
////                                }
////                            }
////                            AdminCardView(
////                                title: "Settings",
////                                subtitle: user == nil ? "Loading..." : "App settings...",
////                                icon: "gearshape.fill",
////                                color: "#796EF3"
////                            ) {
////                                if let user {
////                                    AdminSettingsView(userID: user.id)
////                                } else {
////                                    ProgressView()
////                                }
////                            }
//                            
//                            if let user = user {
//                                AdminCardView(
//                                    title: "Settings",
//                                    subtitle: "App settings...",
//                                    icon: "gearshape.fill",
//                                    color: "#796EF3"
//                                ) {
//                                    AdminSettingsView(userID: user.id)
//                                }
//                            } else {
//                                AdminCardView(
//                                    title: "Settings",
//                                    subtitle: "Loading...",
//                                    icon: "gearshape.fill",
//                                    color: "#CCCCCC"
//                                ) {
//                                    EmptyView()
//                                }
//                                .disabled(true)
//                            }
//
//
//
//                                
//                             
//
//                        }
//
//                    }
//                    .padding()
//                    .background(Color(hex: "#F6F7FB"))
//                    .cornerRadius(20)
//                    .padding(.horizontal)
//
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Recent Activity")
//                            .font(.system(size: 18, weight: .semibold))
//                            .padding(.bottom, 5)
//
//                        ForEach(recentActivity, id: \.0) { activity in
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text(activity.0)
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.black)
//                                Text(activity.1)
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.gray)
//                                Text(activity.2)
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(12)
//                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//                        }
//                    }
//                    .padding(.horizontal)
//
//                    Button {
//                        appState.logout()
//                    } label: {
//                        HStack {
//                            Image(systemName: "rectangle.portrait.and.arrow.right")
//                            Text("Logout")
//                        }
//                        .foregroundColor(.red)
//                        .fontWeight(.semibold)
//                        .padding(.vertical, 12)
//                        .frame(maxWidth: .infinity)
//                    }
//                    .padding(.horizontal)
//                    .padding(.bottom, 20)
//                    .navigationBarBackButtonHidden(true)
//                }
//            }
//            .onAppear {
//                APIService.shared.fetchadmin(userID: appState.userID) { result in
//                    DispatchQueue.main.async {
//                        isLoadingAdmin = false
//                        switch result {
//                        case .success(let fetchedUser):
//                            self.user = fetchedUser
//                        case .failure(let err):
//                            fetchError = err.localizedDescription
//                        }
//                    }
//                }
//            }
//
//        }
//    }
//}

struct AdminCardView<Destination: View>: View {
   

    var title: String
    var subtitle: String
    var icon: String
    var color: String
    let destination: () -> Destination

    init(
        title: String,
        subtitle: String,
        icon: String,
        color: String,
        @ViewBuilder destination: @escaping () -> Destination
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination()) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: color))
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .frame(height: 140)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "#E0E0E0"), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}



// MARK: - Quick Stat Box
struct StatBox: View {
    var title: String
    var value: String

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 2)
    }
}

// MARK: - Hex Color Extension

struct AdminProfileImage: View {
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

// MARK: - Admin Card View
//struct AdminCardView: View {
//    var title: String
//    var subtitle: String
//    var icon: String
//    var color: String
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Image(systemName: icon)
//                .font(.system(size: 24))
//                .foregroundColor(Color(hex: color))
//            Text(title)
//                .font(.system(size: 15, weight: .semibold))
//            Text(subtitle)
//                .font(.system(size: 13))
//                .foregroundColor(.gray)
//            Spacer()
//            HStack {
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding()
//        .frame(height: 140)
//        .background(Color.white)
//        .cornerRadius(16)
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(Color(hex: "#E0E0E0"), lineWidth: 1)
//        )
//    }
//}
struct Opensettings<Destination: View>: View {

    let destination: Destination

    @State private var isPresented = false

    init(@ViewBuilder destination: () -> Destination) {

        self.destination = destination()
    }

    var body: some View {
            NavigationLink(destination: destination, isActive: $isPresented) {
                EmptyView()
            }
            .hidden()
    }
}
