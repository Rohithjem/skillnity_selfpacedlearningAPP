import SwiftUI
import Foundation

// MARK: - CustomTextField
struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
            TextField(placeholder, text: $text)
                .foregroundColor(.black)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color(hexString: "#A99CFF"), lineWidth: 1.5)
        )
    }
}

// MARK: - SecureTextField
struct SecureTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
            if isVisible {
                TextField(placeholder, text: $text)
            } else {
                SecureField(placeholder, text: $text)
            }
            Button(action: {
                isVisible.toggle()
            }) {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color(hexString: "#A99CFF"), lineWidth: 1.5)
        )
    }
}

// MARK: - RegistrationView
struct RegistrationView: View {
    @State private var username = ""
    @State private var collegeName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var navigateToLogin = false
    @ObservedObject private var appState = AppState.shared

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(hexString: "#A99CFF").ignoresSafeArea()

                    ScrollView {
                        VStack(spacing: 20) {
                            Spacer().frame(height: geometry.size.height * 0.05)

                            Image("registration")
                                .resizable()
                                .scaledToFit()
                                .frame(height: geometry.size.height * 0.25)

                            VStack(spacing: 18) {
                                Text("REGISTRATION")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(hexString: "#7D5FFF"))

                                CustomTextField(icon: "person", placeholder: "Username", text: $username)
                                CustomTextField(icon: "building.columns", placeholder: "College name", text: $collegeName)
                                CustomTextField(icon: "at", placeholder: "E-mail", text: $email)
                                SecureTextField(icon: "lock", placeholder: "Password", text: $password, isVisible: $isPasswordVisible)
                                SecureTextField(icon: "lock", placeholder: "Confirm Password", text: $confirmPassword, isVisible: $isConfirmPasswordVisible)

                                Button(action: {
                                    registerUser()
                                }) {
                                    Text("Register")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(hexString: "#7D5FFF"))
                                        .cornerRadius(25)
                                }
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(35)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)

                            HStack {
                                Text("Already have an account?")
                                    .foregroundColor(.black)
                                    .font(.system(size: 14))
                                Button("Login") {
                                    navigateToLogin = true
                                }
                                .foregroundColor(Color(hexString: "#7D5FFF"))
                                .font(.system(size: 14, weight: .semibold))
                            }

                            Spacer()
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            // MARK: - Navigation
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }

            .navigationDestination(isPresented: $appState.isLoggedIn) {
                HomeView(userID: appState.userID ?? 0, username: appState.username)
            }
        }
    }

    func registerUser() {
        guard !username.isEmpty, !collegeName.isEmpty, !email.isEmpty, !password.isEmpty else {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }

        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }

        guard let url = URL(string: "http://localhost/skillnity/register.php") else {
            alertMessage = "Invalid server URL."
            showAlert = true
            return
        }

        let body: [String: String] = [
            "username": username,
            "collegeName": collegeName,
            "email": email,
            "password": password
        ]

        guard let finalBody = try? JSONSerialization.data(withJSONObject: body) else {
            alertMessage = "Failed to create request body."
            showAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = "Request error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                guard let data = data else {
                    alertMessage = "No data received."
                    showAlert = true
                    return
                }

                do {
                    if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let success = result["success"] as? Bool, success {
                            if let _ = result["id"] as? Int,
                               let _ = result["username"] as? String {
                                AppState.shared.logout()
                                self.username = ""
                                self.collegeName = ""
                                self.email = ""
                                self.password = ""
                                self.confirmPassword = ""

                                self.alertMessage = "Registration successful! Please login."
                                self.showAlert = true
                                self.navigateToLogin = true



                            } else {
                                alertMessage = "User ID missing in response."
                                showAlert = true
                            }
                        } else {
                            alertMessage = result["message"] as? String ?? "Registration failed."
                            showAlert = true
                        }
                    } else {
                        alertMessage = "Invalid server response."
                        showAlert = true
                    }
                } catch {
                    alertMessage = "Error parsing response."
                    showAlert = true
                }
            }
        }.resume()
    }
}
