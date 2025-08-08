import SwiftUI

//struct ContentView: View {
//    @StateObject private var appState = AppState.shared
//
//    var body: some View {
//        NavigationStack {
//            if appState.isLoggedIn, let userID = appState.userID {
//                HomeView(userID: userID, username: appState.username)
//            } else {
//                IntroductionView()
//            }
//        }
//        .animation(.easeInOut, value: appState.isLoggedIn)
//    }
//}
//struct ContentView: View {
//    @StateObject private var appState = AppState.shared
//
//    var body: some View {
//        NavigationStack {
//            if appState.isLoggedIn {
//                if appState.isAdmin {
//                    AdminHomeView(adminID: appState.userID, adminUsername: appState.username)
//                } else {
//                    HomeView(userID: appState.userID, username: appState.username)
//                }
//            } else {
//                IntroductionView()
//            }
//        }
//        .animation(.easeInOut, value: appState.isLoggedIn)
//    }
//}
//struct ContentView: View {
//    @StateObject private var appState = AppState.shared
//
//    var body: some View {
//        NavigationStack {
//            if appState.isLoggedIn {
//                if appState.isAdmin {
//                    AdminHomeView()
//                } else {
//                    HomeView()
//                }
//            } else {
//                IntroductionView()
//            }
//        }
//        .animation(.easeInOut, value: appState.isLoggedIn)
//    }
//}
struct ContentView: View {
    @StateObject private var appState = AppState.shared

    var body: some View {
        NavigationStack {
            if appState.isLoggedIn {
                if appState.isAdmin {
                    AdminHomeView()
                } else {
                    HomeView(userID: appState.userID, username: appState.username)
                }
            } else {
                IntroductionView()
            }
        }
        .animation(.easeInOut, value: appState.isLoggedIn)
    }
}
