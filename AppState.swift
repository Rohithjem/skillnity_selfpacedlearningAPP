//import Foundation

//class AppState: ObservableObject {
//    static let shared = AppState()
//    @Published var profileUpdated: Bool = false
//    @Published var isLoggedIn: Bool = false
//    @Published var userID: Int? = nil
//    @Published var username: String = ""
//    private init() {}
//    
//    func logout() {
//        isLoggedIn = false
//        userID = nil
//        username = ""
//    }
//}
import Foundation
import SwiftUI

//class AppState: ObservableObject {
//    static let shared = AppState()
//    @Published var profileUpdated: Bool = false
//    @Published var isLoggedIn: Bool
//    @Published var isAdmin: Bool
//    @Published var userID: Int
//    @Published var username: String
//
//    private init() {
//        self.userID = UserDefaults.standard.integer(forKey: "userID")
//        self.username = UserDefaults.standard.string(forKey: "username") ?? ""
//        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
//        self.isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
//    }
//
//    func login(userID: Int, username: String, isAdmin: Bool) {
//        self.userID = userID
//        self.username = username
//        self.isAdmin = isAdmin
//        self.isLoggedIn = true
//
//        UserDefaults.standard.set(userID, forKey: "userID")
//        UserDefaults.standard.set(username, forKey: "username")
//        UserDefaults.standard.set(isAdmin, forKey: "isAdmin")
//        UserDefaults.standard.set(true, forKey: "isLoggedIn")
//    }
//
//    func logout() {
//        self.userID = 0
//        self.username = ""
//        self.isAdmin = false
//        self.isLoggedIn = false
//
//        UserDefaults.standard.removeObject(forKey: "userID")
//        UserDefaults.standard.removeObject(forKey: "username")
//        UserDefaults.standard.removeObject(forKey: "isAdmin")
//        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
//    }
//}
enum RootViewState{
    case login
    case signUpSuccess
    case signup
    case forgotPassword
    case resetPassword
    case backToPosts
    case home
}

class AppState: ObservableObject {
    static let shared = AppState()

    @Published var profileUpdated: Bool = false
    @Published var isLoggedIn: Bool
    @Published var isAdmin: Bool
    @Published var userID: Int
    @Published var username: String
    @Published var rootViewState: RootViewState = .login
    @Published var emailForReset: String = ""
    @Published var isOTPVerified = false
    @Published var isChanged = false
    @Published var isFirstLaunch: Bool = true
    
    
    

//    private init() {
//        self.userID = UserDefaults.standard.integer(forKey: "userID")
//        self.username = UserDefaults.standard.string(forKey: "username") ?? ""
//        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
//        self.isAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
//    }
    private init() {
        self.userID = 0
        self.username = ""
        self.isLoggedIn = false
        self.isAdmin = false
    }


    func login(userID: Int, username: String, isAdmin: Bool) {
        self.userID = userID
        self.username = username
        self.isAdmin = isAdmin
        self.isLoggedIn = true

//        UserDefaults.standard.set(userID, forKey: "userID")
//        UserDefaults.standard.set(username, forKey: "username")
//        UserDefaults.standard.set(isAdmin, forKey: "isAdmin")
//        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }

    func logout() {
        self.userID = 0
        self.username = ""
        self.isAdmin = false
        self.isLoggedIn = false
        isFirstLaunch = true

//        UserDefaults.standard.removeObject(forKey: "userID")
//        UserDefaults.standard.removeObject(forKey: "username")
//        UserDefaults.standard.removeObject(forKey: "isAdmin")
//        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
    }
    
}
