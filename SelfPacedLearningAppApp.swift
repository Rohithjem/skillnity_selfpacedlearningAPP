//
//  SelfPacedLearningAppApp.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 06/05/25.
//

import SwiftUI

//@main
// struct SelfPacedLearningAppApp: App {
//    var body: some Scene {
//        WindowGroup {
//            IntroductionView()
//            
//        }
//    }
//}
//@main
//struct SelfPacedLearningAppApp: App {
//    @StateObject var appState = AppState.shared
//
//    var body: some Scene {
//        WindowGroup {
//            if appState.isLoggedIn {
//                if appState.isAdmin {
//                    AdminHomeView(userID: appState.userID, username: appState.username)
//                } else {
//                    HomeView(userID: appState.userID, username: appState.username)
//                }
//            } else {
//                IntroductionView()
//            }
//        }
//    }
//}
//@main
//struct SelfPacedLearningAppApp: App {
//    @StateObject var appState = AppState.shared
//
//    var body: some Scene {
//        WindowGroup {
//            if appState.isLoggedIn {
//                if appState.isAdmin {
//                    AdminHomeView()
//                } else {
//                    HomeView(userID: appState.userID, username: appState.username)
//                        .id(appState.userID)
//                }
//            } else {
//                IntroductionView()
//            }
//        }
//    }
//}
//@main
//struct SelfPacedLearningAppApp: App {
//    @StateObject var appState = AppState.shared
//
//    var body: some Scene {
//        WindowGroup {
//            if appState.isLoggedIn {
//                NavigationStack {
//                    if appState.isAdmin {
//                        AdminHomeView()
//                    } else {
//                        HomeView(userID: appState.userID, username: appState.username)
//                    }
//                }
//            } else {
//                IntroductionView()
//            }
//        }
//    }
//}
//@main
//struct SelfPacedLearningAppApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
//@main
//struct SelfPacedLearningAppApp: App {
//    @StateObject var appState = AppState.shared
//
//    var body: some Scene {
//        WindowGroup {
//            RootView()
//                .environmentObject(appState)
//        }
//    }
//}


@main
struct SelfPacedLearningAppApp: App {
    @StateObject var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AppState.shared)
        }
    }
}




//@main
//struct SelfPacedLearningAppApp: App {
//    @StateObject var appState = AppState.shared
//
//    var body: some Scene {
//        WindowGroup {
//            if appState.isLoggedIn {
//                if appState.isAdmin {
//                    AdminHomeView()
//                } else {
//                    HomeView(userID: appState.userID, username: appState.username)
//                }
//            } else {
//                IntroductionView()
//            }
//        }
//    }
//}
