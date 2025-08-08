//
//  AdminLoginView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 28/07/25.
//

import Foundation
import SwiftUI

struct AdminLoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isadminloading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @ObservedObject private var appState = AppState.shared
    @State private var showForgotPassword = false
    @Environment(\.dismiss) var dismiss
//    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
//    @State private var navigate = false
    
    // Inside your login success block:
    

    
    var body: some View {
        ZStack {
            
            
            Color(hex: "#796EF3") // Background color
                .ignoresSafeArea()
            
            
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    Spacer()
                }
                .padding()
                // MARK: - Back button and Time (optional custom header can be added)
                //                HStack {
                //                    Image(systemName: "chevron.left")
                //                        .foregroundColor(.black)
                //                        .padding(.leading, 20)
                //                    Spacer()
                //                }
                //                .padding(.top, 40)
                
                // MARK: - Top Illustration
                Image("login") // Replace with your Lottie/PNG image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                // MARK: - Login Card
                VStack(spacing: 20) {
                    Text("Admin LOGIN")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "#796EF3"))
                    
                    // Username Field
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                        TextField("Username", text: $username)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#796EF3"), lineWidth: 1.5)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                            .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                    
                    // Password Field
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.black)
                        
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .foregroundColor(.black)
                        } else {
                            SecureField("Password", text: $password)
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#796EF3"), lineWidth: 1.5)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                            .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                    
                    // Login Button
                    
                    
                    Button(action: {
                        isadminloading = true
                        adminlogin()
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hexString: "#6F59FF"))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal)
                    // Forgot Password
//                    HStack {
//                        Text("Forgot password?")
//                            .foregroundColor(.black)
//                            .font(.system(size: 14))
//                        Button(action: {
//                            // Forgot password action
//                        }) {
//                            Text("Click")
//                                .foregroundColor(Color(hex: "#796EF3"))
//                                .font(.system(size: 14))
//                        }
//                    }
//                    .padding(.bottom, 10)
//                    HStack {
//                        Text("Forgot password?").foregroundColor(.black)
//                        Button("Click") {
//                            showForgotPassword = true
//                        }
//                        .foregroundColor(Color(hexString: "#6F59FF"))
//
//                    }.font(.system(size: 13))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .shadow(radius: 5)
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Login Failed"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
//            .navigationDestination(isPresented: $appState.isLoggedIn) {
//                AdminHomeView(userID: appState.userID ?? 0, username: appState.username)
//            }
//            .navigationDestination(isPresented: $appState.isLoggedIn) {
//                AdminHomeView()
//            }
            .navigationDestination(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
//            .navigationDestination(isPresented: $isLoggedIn) {
//                AdminHomeView()
//            }
//            .navigationDestination(isPresented: $navigate) {
//                AdminHomeView()
//            }


            .navigationBarBackButtonHidden(true)
        }
    }
    func adminlogin() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both username and password"
            showError = true
            return
        }

        guard let url = URL(string: "http://localhost/skillnity/adminlogin.php") else {
            errorMessage = "Invalid server URL"
            showError = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 👍 Use real input
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.isadminloading = false
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    self.showError = true
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server"
                    self.showError = true
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                if result.success, let id = result.id, let fetchedUsername = result.username {
                    DispatchQueue.main.async {
//                        @AppStorage("userID") var storedUserID: Int = 0
//                        @AppStorage("username") var storedUsername: String = ""
//                        @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
//
//                        // Inside DispatchQueue.main.async:
//                        storedUserID = id
//                        storedUsername = fetchedUsername
//                        isLoggedIn = true
                        
                        self.isadminloading = false
                        appState.login(userID: id, username: fetchedUsername, isAdmin: true)
                        print("Admin login success")
                        print("LoggedIn: \(appState.isLoggedIn)")
                        print("IsAdmin: \(appState.isAdmin)")
                        //dismiss()


                    }
                } else {
                    DispatchQueue.main.async {
                        self.isadminloading = false
                        self.errorMessage = result.message ?? "Login failed"
                        self.showError = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error decoding server response"
                    self.showError = true
                }
            }
        }.resume()
    }
    struct LoginResponse: Codable {
        let success: Bool
        let id: Int?
        let username: String?
        let message: String?
    }

    
    // MARK: - Hex Color Extension

        }

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
