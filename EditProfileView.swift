import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Binding var user: User?
    let userID: Int
    
    @Environment(\.dismiss) private var dismiss
    @State private var newEmail: String = ""
    @State private var newCollegeName: String = ""
    @State private var newUsername: String = ""
    @State private var selectedImage: UIImage?
    @State private var photoItem: PhotosPickerItem?
    @State private var isUploading = false
    @State private var uploadError: String?
    @State private var newPassword: String = ""
    @State private var showSuccess = false



    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Profile")
                .font(.title2)
                .bold()
                .foregroundColor(.themePurple)
            
            // MARK: - Profile Image Picker
            PhotosPicker(selection: $photoItem, matching: .images) {
                Group {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        AsyncImage(url: URL(string: user?.profile_pic ?? "")) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            }
            .onChange(of: photoItem) { newItem in
                if let newItem {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
            }

            // MARK: - Username Field
            TextField("Enter new username", text: $newUsername)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .foregroundColor(.black)
            TextField("Enter new email", text: $newEmail)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .foregroundColor(.black)

            TextField("Enter new college name", text: $newCollegeName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .foregroundColor(.black)
            SecureField("Enter new password", text: $newPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .foregroundColor(.black)


            // MARK: - Save Button
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                updateProfile()
            }) {
                if isUploading {
                    ProgressView().tint(.white)
                } else {
                    Text("Save Changes")
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.themePurple)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)

            // MARK: - Error message
            if let uploadError {
                Text(uploadError)
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }

            Spacer()
        }
        .padding(.top)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            newUsername = user?.username ?? ""
            newEmail = user?.email ?? ""
            newCollegeName = user?.college_name ?? ""
        }
        .alert(isPresented: $showSuccess) {
            Alert(title: Text("Success"), message: Text("Profile updated!"), dismissButton: .default(Text("OK")))
        }


    }
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
    }

    // MARK: - Update Profile Function
    func updateProfile() {
        guard isValidEmail(newEmail) else {
            uploadError = "Invalid email format"
            return
        }

        guard !newUsername.isEmpty else { return }
        isUploading = true
        uploadError = nil

        guard let url = URL(string: "http://localhost/skillnity/update_profile.php") else {
            uploadError = "Invalid server URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add user_id
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n")
        body.append("\(userID)\r\n")

        // Add username
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n")
        body.append("\(newUsername)\r\n")
        
        // Add email
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n")
        body.append("\(newEmail)\r\n")

        // Add college_name
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"college_name\"\r\n\r\n")
        body.append("\(newCollegeName)\r\n")


        // Add profile_pic if available
        if let image = selectedImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"profile_pic\"; filename=\"profile.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { self.isUploading = false }

            if let error = error {
                DispatchQueue.main.async {
                    uploadError = "Network error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    uploadError = "No response from server"
                }
                return
            }

            let rawResponse = String(data: data, encoding: .utf8) ?? "Unreadable data"

            // Debug log
            print("🔵 Server response: \(rawResponse)")

            if let decoded = try? JSONDecoder().decode(User.self, from: data) {
                DispatchQueue.main.async {
                    self.user = decoded
                    self.showSuccess = true
                    AppState.shared.profileUpdated = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    uploadError = "❌ Update failed or invalid JSON:\n\n\(rawResponse)"
                }
            }
        }.resume()
    }
}

// MARK: - Data Append Helper
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

