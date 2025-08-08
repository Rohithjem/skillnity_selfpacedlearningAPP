//
//  RootView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 30/07/25.
//

import Foundation
import SwiftUI

//struct RootView: View {
//    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
//    @AppStorage("isAdmin") var isAdmin: Bool = false
//
//    var body: some View {
//        if isLoggedIn {
//            if isAdmin {
//                AdminHomeView()
//            } else {
//                HomeView(userID: UserDefaults.standard.integer(forKey: "userID"),
//                         username: UserDefaults.standard.string(forKey: "username") ?? "")
//            }
//        } else {
//            IntroductionView()
//        }
//    }
//}
//struct RootView: View {
//    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
//    @AppStorage("isAdmin") var isAdmin: Bool = false
//    @StateObject private var appState = AppState.shared
//
//    
//
//    var body: some View {
//        if isLoggedIn {
//            if isAdmin {
//                AdminHomeView(user: nil as User?) // or AdminUser?
//            } else {
//                HomeView(
//                    userID: UserDefaults.standard.integer(forKey: "userID"),
//                    username: UserDefaults.standard.string(forKey: "username") ?? ""
//                )
//            }
//        } else {
//            IntroductionView()
//        }
//    }
//}
//struct RootView: View {
//    @StateObject private var appState = AppState.shared
//
//    var body: some View {
//        if appState.isLoggedIn {
//            if appState.isAdmin {
//                AdminHomeView() // no need to pass user; it loads internally
//            } else {
//                HomeView(
//                    userID: appState.userID,
//                    username: appState.username
//                )
//            }
//        } else {
//            IntroductionView()
//        }
//    }
//}
//
//struct RootView: View {
//    @StateObject private var appState = AppState.shared
//
//    var body: some View {
//        if appState.isLoggedIn {
//            if appState.isAdmin {
//                AdminHomeView()
//            } else {
//                HomeView(userID: appState.userID, username: appState.username)
//            }
//        } else {
//            IntroductionView()
//        }
//    }
//}

//struct RootView: View {
//    @EnvironmentObject var appState: AppState // Use existing instance
//
//    var body: some View {
//        if appState.isLoggedIn {
//            if appState.isAdmin {
//                AdminHomeView()
//            } else {
//                HomeView(userID: appState.userID, username: appState.username)
//            }
//        } else {
//            IntroductionView()
//        }
//    }
//}
//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        ZStack {
//            // Always load base view (e.g. Introduction)
//            IntroductionView()
//                .fullScreenCover(isPresented: $appState.isLoggedIn) {
//                    if appState.isAdmin {
//                        AdminHomeView()
//                    } else {
//                        HomeView(userID: appState.userID, username: appState.username)
//                    }
//                }
//        }
//    }
//}
//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//    var body: some View {
//        Group {
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

//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//    var body: some View {
//        Group {
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


//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        NavigationStack {
//            Group {
//                if appState.isLoggedIn {
//                    if appState.isAdmin {
//                        AdminHomeView()
//                    } else {
//                        HomeView(userID: appState.userID, username: appState.username)
//                    }
//                } else {
//                    IntroductionView()
//                }
//            }
//        }
//    }
//}

//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//    var body: some View {
//        Group {
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
import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.isChanged {
            // After password reset
            LoginView()
                .onAppear {
                    // Reset flags after navigating to login
                    appState.isChanged = false
                    appState.isOTPVerified = false
                }

        } else if appState.isOTPVerified {
            // After OTP verified, go to reset password
            PasswordResetView(email: appState.emailForReset)

        } else if appState.isLoggedIn {
            // Go to Home or Admin view based on role
            NavigationStack {
                if appState.isAdmin {
                    AdminHomeView()
                } else {
                    HomeView(userID: appState.userID, username: appState.username)
                }
            }
        }

        else {
            // Default: Show login
            IntroductionView()
        }
    }

    
}
//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        Group {
//            if appState.isOTPVerified {
//                PasswordResetView(email: appState.emailForReset)
//            }
//            if appState.isChanged{
//                LoginView()
//            }
//            else if appState.isLoggedIn {
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
//import SwiftUI
//
//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        NavigationStack {
//            Group {
//                if appState.isChanged {
//                    // After password reset
//                    LoginView()
//                        .onAppear {
//                            appState.isChanged = false
//                            appState.isOTPVerified = false
//                        }
//
//                } else if appState.isOTPVerified {
//                    // After OTP verified
//                    PasswordResetView(email: appState.emailForReset)
//
//                } else if appState.isLoggedIn {
//                    if appState.isAdmin {
//                        AdminHomeView()
//                    } else {
//                        HomeView(userID: appState.userID, username: appState.username)
//                    }
//
//                } else {
//                    IntroductionView()
//                }
//            }
//        }
//    }
//}
//import SwiftUI
////
//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        NavigationStack {
//            if appState.isChanged {
//                // After password reset
//                LoginView()
//                    .onAppear {
//                        appState.isChanged = false
//                        appState.isOTPVerified = false
//                    }
//
//            } else if appState.isOTPVerified {
//                // After OTP verified
//                PasswordResetView(email: appState.emailForReset)
//
//            } else if appState.isLoggedIn {
//                if appState.isAdmin {
//                    AdminHomeView()
//                } else {
//                    HomeView(userID: appState.userID, username: appState.username)
//                }
//
//            } else {
//                IntroductionView()
//            }
//        }
//    }
//}

//import SwiftUI
//
//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        if appState.isChanged {
//            // After password reset
//            LoginView()
//                .onAppear {
//                    // Reset flags after navigating to login
//                    appState.isChanged = false
//                    appState.isOTPVerified = false
//                }
//
//        } else if appState.isOTPVerified {
//            // After OTP verified, go to reset password
//            PasswordResetView(email: appState.emailForReset)
//
//        } else if appState.isLoggedIn {
//            // Go to Home or Admin view based on role
//            NavigationStack {
//                if appState.isAdmin {
//                    AdminHomeView()
//                } else {
//                    HomeView(userID: appState.userID, username: appState.username)
//                }
//            }
//        }
//
//        else {
//            // Default: Show login
//            IntroductionView()
//        }
//    }
//
//    
//}

//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        Group {
//            switch appState.rootViewState {
//            case .forgotPassword:
//                ForgotPasswordView()
//                
//            case .resetPassword:
//                PasswordResetView(email: appState.emailForReset)
//                
//            case .home:
//                if appState.isAdmin {
//                    AdminHomeView()
//                } else {
//                    HomeView(userID: appState.userID, username: appState.username)
//                }
//            }
//        }
//    }
//}


//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        NavigationStack {
//            Group {
//                if appState.isLoggedIn {
//                    
//                    if appState.isAdmin {
//                        AdminHomeView()
//                            .onAppear {
//                                print("✅ User is logged in: \(appState.username), Admin: \(appState.isAdmin)")
//                            }
//                    } else {
//                        HomeView(userID: appState.userID, username: appState.username)
//                            .onAppear {
//                                print("✅ User is logged in: \(appState.username), Admin: false")
//                            }
//                    }
//                    
//                } else {
//                    IntroductionView()
//                        .onAppear {
//                            print("🚫 Showing IntroductionView")
//                        }
//                }
//            }
//        }
//    }
//
//
//}
//

//struct RootView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        NavigationStack {
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
