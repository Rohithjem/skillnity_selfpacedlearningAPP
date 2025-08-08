//
//  ForgotPasswordView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 07/07/25.
//

import Foundation
import SwiftUI

struct ForgotPassword: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var message = ""
    @State private var showSuccessPopup = false
    @State private var showMessage = false

    var body: some View {
        ZStack {
            Color.themePurple.ignoresSafeArea()

            VStack {
                // Top Back Button
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

                // Image
                Image("forgot_illustration") // Add this image to your Assets
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)

                // Form Section
                VStack(spacing: 20) {
                    Text("🔒 Forgot Password")
                        .font(.headline)
                        .foregroundColor(.themePurple)

                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Enter your email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.themePurple, lineWidth: 1))
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)

                    Button(action: {
                        resetPassword()
                    }) {
                        Text("Reset Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.themePurple)
                            .cornerRadius(20)
                    }

                    Button("Login Now!") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal)
                .shadow(radius: 4)

                Spacer()

                if showMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                        .transition(.opacity)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .background(Color.white.ignoresSafeArea())
        .alert("✅ Success", isPresented: $showSuccessPopup) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Password reset! Please check your email.")
        }
    }

    func resetPassword() {
        guard !email.isEmpty else {
            message = "Please enter your email"
            showTemporaryMessage()
            return
        }

        guard let url = URL(string: "http://localhost/skillnity/reset_password.php") else {
            message = "Invalid URL"
            showTemporaryMessage()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["email": email]
        request.httpBody = try? JSONEncoder().encode(payload)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    message = "No response from server"
                    showTemporaryMessage()
                }
                return
            }

            if let response = try? JSONDecoder().decode(ServerResponse.self, from: data) {
                DispatchQueue.main.async {
                    if response.status == "success" {
                        showSuccessPopup = true
                    } else {
                        message = response.message
                        showTemporaryMessage()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    message = "Invalid response format"
                    showTemporaryMessage()
                }
            }
        }.resume()
    }

    func updatePasswordOnBackend(tempPassword: String) {
        guard let backendURL = URL(string: "http://localhost/skillnity/reset_password.php") else {
            return
        }

        var request = URLRequest(url: backendURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "email": email,
            "password": tempPassword
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                showSuccessPopup = true
            }
        }.resume()
    }


    func showTemporaryMessage() {
        withAnimation {
            showMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                showMessage = false
            }
        }
    }
}

// Server response model
struct ServerResponse: Codable {
    let status: String
    let message: String
}

// Theme extension (if not already added)

