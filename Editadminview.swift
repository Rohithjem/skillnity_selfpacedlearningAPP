//
//  Editadminview.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 01/08/25.
//

import Foundation
import SwiftUI
import PhotosUI


struct EditAdminView: View {
    @Binding var user: AdminUser?
    let userID: Int

    @Environment(\.dismiss) private var dismiss
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

            PhotosPicker(selection: $photoItem, matching: .images) {
                Group {
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                    } else if let urlString = user?.profile_pic,
                              let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                            @unknown default:
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.themePurple, lineWidth: 2))
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

            TextField("Enter new username", text: $newUsername)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .foregroundColor(.black)

            SecureField("Enter new password (leave blank to keep current)", text: $newPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .foregroundColor(.black)

            Button(action: {
                dismissKeyboard()
                updateProfile()
            }) {
                if isUploading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Save Changes")
                        .bold()
                }
            }
            .disabled(isUploading || newUsername.trimmingCharacters(in: .whitespaces).isEmpty)
            .frame(maxWidth: .infinity)
            .padding()
            .background((isUploading || newUsername.trimmingCharacters(in: .whitespaces).isEmpty) ? Color.gray : Color.themePurple)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)

            if let uploadError {
                Text(uploadError)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }

            Spacer()
        }
        .padding(.top)
        .background(Color.white)
        .ignoresSafeArea()
        .onAppear {
            newUsername = user?.username ?? ""
        }
        .alert(isPresented: $showSuccess) {
            Alert(title: Text("Success"),
                  message: Text("Profile updated!"),
                  dismissButton: .default(Text("OK")) {
                      dismiss()
                  })
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func updateProfile() {
        guard !newUsername.trimmingCharacters(in: .whitespaces).isEmpty else {
            uploadError = "Username cannot be empty."
            return
        }

        isUploading = true
        uploadError = nil

        guard let url = URL(string: "http://localhost/skillnity/update_admin_profile.php") else {
            uploadError = "Invalid server URL"
            isUploading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func appendField(name: String, value: String) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        appendField(name: "user_id", value: "\(userID)")
        appendField(name: "username", value: newUsername)
        if !newPassword.isEmpty {
            appendField(name: "password", value: newPassword)
        }

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

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async { self.isUploading = false }

            if let error = error {
                DispatchQueue.main.async {
                    uploadError = "Network error: \(error.localizedDescription)"
                }
                return
            }

            guard let data else {
                DispatchQueue.main.async {
                    uploadError = "No response from server"
                }
                return
            }

            let rawResponse = String(data: data, encoding: .utf8) ?? "Unreadable data"
            print("🔵 update_admin_profile response:", rawResponse)

            // Assume backend returns same shape as admin fetch
            do {
                let decoded = try JSONDecoder().decode(WrappedResponse<AdminUser>.self, from: data)
                if let updated = decoded.data {
                    DispatchQueue.main.async {
                        self.user = updated
                        self.showSuccess = true
                        AppState.shared.profileUpdated = true
                    }
                } else {
                    DispatchQueue.main.async {
                        uploadError = decoded.message ?? "Update failed"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    uploadError = "Update failed: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

// Data Append Helper
//extension Data {
//    mutating func append(_ string: String) {
//        if let d = string.data(using: .utf8) {
//            append(d)
//        }
//    }
//}

//struct EditAdminView: View {
//    @Binding var user: AdminUser?
//        let userID: Int
//
//    @Environment(\.dismiss) private var dismiss
//
//    @State private var newUsername: String = ""
//    @State private var selectedImage: UIImage?
//    @State private var photoItem: PhotosPickerItem?
//    @State private var isUploading = false
//    @State private var uploadError: String?
//    @State private var newPassword: String = ""
//    @State private var showSuccess = false
//
//    
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Edit Profile")
//                .font(.title2)
//                .bold()
//                .foregroundColor(.themePurple)
//
//            // Profile Image Picker
//            PhotosPicker(selection: $photoItem, matching: .images) {
//                Group {
//                    if let selectedImage {
//                        Image(uiImage: selectedImage)
//                            .resizable()
//                            .scaledToFill()
//                    } else if let urlString = user?.profile_pic,
//                              let url = URL(string: urlString) {
//                        AsyncImage(url: url) { phase in
//                            switch phase {
//                            case .empty:
//                                ProgressView()
//                                    .frame(width: 100, height: 100)
//                            case .success(let image):
//                                image
//                                    .resizable()
//                                    .scaledToFill()
//                            case .failure:
//                                Image(systemName: "person.crop.circle.fill")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .foregroundColor(.gray)
//                            @unknown default:
//                                Image(systemName: "person.crop.circle.fill")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    } else {
//                        Image(systemName: "person.crop.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .foregroundColor(.gray)
//                    }
//                }
//                .frame(width: 100, height: 100)
//                .clipShape(Circle())
//                .overlay(Circle().stroke(Color.themePurple, lineWidth: 2))
//            }
//            .onChange(of: photoItem) { newItem in
//                if let newItem {
//                    Task {
//                        if let data = try? await newItem.loadTransferable(type: Data.self),
//                           let uiImage = UIImage(data: data) {
//                            selectedImage = uiImage
//                        }
//                    }
//                }
//            }
//
//            // Username
//            TextField("Enter new username", text: $newUsername)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//                .padding(.horizontal)
//                .foregroundColor(.black)
//
//
//
//            // Password (optional)
//            SecureField("Enter new password (leave blank to keep current)", text: $newPassword)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//                .padding(.horizontal)
//                .foregroundColor(.black)
//
//            // Save Button
//            Button(action: {
//                dismissKeyboard()
//                updateProfile()
//            }) {
//                if isUploading {
//                    ProgressView()
//                        .tint(.white)
//                } else {
//                    Text("Save Changes")
//                        .bold()
//                }
//            }
//            
//            .disabled(isUploading || newUsername.trimmingCharacters(in: .whitespaces).isEmpty)
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(
//                (isUploading || newUsername.trimmingCharacters(in: .whitespaces).isEmpty)
//                    ? Color.gray
//                    : Color.themePurple
//            )
//            .foregroundColor(.white)
//            .cornerRadius(12)
//            .padding(.horizontal)
//
//           
//            if let uploadError {
//                Text(uploadError)
//                    .foregroundColor(.red)
//                    .multilineTextAlignment(.center)
//                    .padding(.top, 8)
//            }
//
//            Spacer()
//        }
//        .padding(.top)
//        .background(Color.white)
//        .onAppear {
//            newUsername = user?.username ?? ""
//
//        }
//        .alert(isPresented: $showSuccess) {
//            Alert(title: Text("Success"),
//                  message: Text("Profile updated!"),
//                  dismissButton: .default(Text("OK")) {
//                      dismiss()
//                  })
//        }
//    }
//
//    // MARK: - Helpers
//
//    private func dismissKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
//                                        to: nil, from: nil, for: nil)
//    }
//
//    // MARK: - Network
//
//    private func updateProfile() {
//        // Basic validation
//        guard !newUsername.trimmingCharacters(in: .whitespaces).isEmpty else {
//            uploadError = "Username cannot be empty."
//            return
//        }
//        
//        isUploading = true
//        uploadError = nil
//
//        guard let url = URL(string: "http://localhost/skillnity/update_admin_profile.php") else {
//            uploadError = "Invalid server URL"
//            isUploading = false
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        var body = Data()
//
//        func appendField(name: String, value: String) {
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
//            body.append("\(value)\r\n")
//        }
//
//        appendField(name: "user_id", value: "\(userID)")
//        appendField(name: "username", value: newUsername)
//  
//        if !newPassword.isEmpty {
//            appendField(name: "password", value: newPassword)
//        }
//
//        if let image = selectedImage,
//           let imageData = image.jpegData(compressionQuality: 0.8) {
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"profile_pic\"; filename=\"profile.jpg\"\r\n")
//            body.append("Content-Type: image/jpeg\r\n\r\n")
//            body.append(imageData)
//            body.append("\r\n")
//        }
//
//        body.append("--\(boundary)--\r\n")
//        request.httpBody = body
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async { self.isUploading = false }
//
//            if let error = error {
//                DispatchQueue.main.async {
//                    uploadError = "Network error: \(error.localizedDescription)"
//                }
//                return
//            }
//
//            guard let data else {
//                DispatchQueue.main.async {
//                    uploadError = "No response from server"
//                }
//                return
//            }
//
//            let rawResponse = String(data: data, encoding: .utf8) ?? "Unreadable data"
//            print("🔵 Server response: \(rawResponse)")
//
//            if let decoded = try? JSONDecoder().decode(User.self, from: data) {
//                DispatchQueue.main.async {
//                    self.user = decoded
//                    self.showSuccess = true
//                    AppState.shared.profileUpdated = true
//                }
//            } else {
//                DispatchQueue.main.async {
//                    uploadError = "Update failed or invalid response from server."
//                }
//            }
//        }.resume()
//    }
//}

// MARK: - Data Append Helper

