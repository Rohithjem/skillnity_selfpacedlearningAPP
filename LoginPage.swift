import SwiftUI


struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var showRegistration = false
    @State private var showError = false
    @State private var errorMessage = ""
    @ObservedObject private var appState = AppState.shared
    @State private var isLoading = false
    @State private var showForgotPassword = false
    @State private var isadmin = false
    @Environment(\.dismiss) var dismiss


    var body: some View {
        NavigationStack {
            ZStack {
                Color.themePurple.ignoresSafeArea()

                VStack(spacing: 20) {
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
//                    Spacer().frame(height: 40)

                    Image("login")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)

                    VStack(spacing: 18) {
                        Text("LOGIN")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hexString: "#6F59FF"))

                        // Username field
                        HStack {
                            Image(systemName: "person.fill").foregroundColor(.black)
                            TextField("Username", text: $username)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 25).stroke(Color(hexString: "#6F59FF")))
                        .padding(.horizontal)

                        // Password field
                        HStack {
                            Image(systemName: "lock.fill").foregroundColor(.black)
                            if isPasswordVisible {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
                            }
                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 25).stroke(Color(hexString: "#6F59FF")))
                        .padding(.horizontal)

                        // Login Button
                        Button(action: {
                            isLoading = true
                            login()
                        }) {
                            Text("Login")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hexString: "#6F59FF"))
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                        .disabled(isLoading)

                        .padding(.horizontal)

                        // Forgot password
                        HStack {
                            Text("Forgot password?").foregroundColor(.black)
                            Button("Click") {
                                showForgotPassword = true
                            }
                            .foregroundColor(Color(hexString: "#6F59FF"))

                        }.font(.system(size: 13))

                        // Sign Up
                        HStack {
                            Text("Don't have an Account?").foregroundColor(.gray)
                            Button("SignUp") {
                                showRegistration = true
                            }
                            .foregroundColor(Color(hexString: "#6F59FF"))
                        }.font(.system(size: 13))

                        // Admin Login
                        
                        Button("Admin Login") {
                            isadmin = true
                            
                        }
                            .font(.system(size: 13))
                            .foregroundColor(Color(hexString: "#6F59FF"))
                    }
                    .padding(.top)
                    .padding(.bottom, 30)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)

                    Spacer()
                }
                .onAppear {
                    self.username = ""
                    self.password = ""
                    self.showError = false
                }

            }
            // Navigate to RegistrationView
            .navigationDestination(isPresented: $showRegistration) {
                RegistrationView()
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Login Failed"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $appState.isLoggedIn) {
                HomeView(userID: appState.userID ?? 0, username: appState.username)
            }
            .navigationDestination(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
            .navigationDestination(isPresented: $isadmin) {
                AdminLoginView()
            }
            .navigationBarBackButtonHidden(true)
            


        }
    }

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both username and password"
            showError = true
            return
        }

        guard let url = URL(string: "http://localhost/skillnity/login.php") else {
            errorMessage = "Invalid server URL"
            showError = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyData = "username=\(username)&password=\(password)"
        request.httpBody = bodyData.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
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
                        // ✅ Update global app state
                        AppState.shared.userID = id
                        AppState.shared.username = fetchedUsername
                        AppState.shared.isLoggedIn = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
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
}

// MARK: - Supporting Models

struct LoginResponse: Codable {
    let success: Bool
    let id: Int?
    let username: String?
    let message: String?
}
