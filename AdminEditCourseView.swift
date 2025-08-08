////
////  AdminEditCourseView.swift
////  SelfPacedLearningApp
////
////  Created by SAIL on 01/08/25.
////
//
import Foundation
import SwiftUI

import PhotosUI

struct AdminEditCourseView: View {
    @Environment(\.dismiss) var dismiss

    @State var course: NewCourse
    @State private var title: String
    @State private var description: String
    @State private var isActive: Bool
    @State private var imageURL: String
    @State private var pickedImage: UIImage? = nil
    @State private var pickedItem: PhotosPickerItem? = nil
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var showAlert = false

    init(course: NewCourse) {
        _course = State(initialValue: course)
        _title = State(initialValue: course.title)
        _description = State(initialValue: course.description)
        _isActive = State(initialValue: course.is_active == 1)
        _imageURL = State(initialValue: course.image_url)
    }

    private var hasChanges: Bool {
        return title != course.title ||
               description != course.description ||
               isActive != (course.is_active == 1) ||
               pickedImage != nil
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                imagePickerSection

                formSection

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .font(.caption)
                }

                buttonsSection
            }
            .padding()
        }
        .navigationTitle(course.id == 0 ? "Add Course" : "Edit Course")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Unknown error")
        }
    }

    // MARK: - Image Picker Section
    private var imagePickerSection: some View {
        PhotosPicker(selection: $pickedItem, matching: .images) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 140)

                if let uiImage = pickedImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 140)
                        .clipped()
                        .cornerRadius(8)
                } else if let url = URL(string: "http://localhost/skillnity\(imageURL)") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(height: 140)
                        case .success(let image):
                            image.resizable().scaledToFill().frame(height: 140).clipped().cornerRadius(8)
                        case .failure:
                            fallbackImage
                        @unknown default:
                            fallbackImage
                        }
                    }
                } else {
                    fallbackImage
                }

                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.purple.opacity(0.6), lineWidth: 2)
                    .frame(height: 140)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Tap to change")
                            .font(.caption)
                            .padding(6)
                            .background(Color.black.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
                .padding(8)
            }
        }
        .onChange(of: pickedItem) { newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    pickedImage = uiImage
                }
            }
        }
    }


    private var fallbackImage: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.1))
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
        .frame(height: 140)
        .cornerRadius(8)
    }

    // MARK: - Form
    private var formSection: some View {
        Group {
            VStack(alignment: .leading, spacing: 6) {
                Text("Title").font(.subheadline).foregroundColor(.gray)
                TextField("Course title", text: $title)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Description").font(.subheadline).foregroundColor(.gray)
                TextEditor(text: $description)
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }

            Toggle("Active", isOn: $isActive)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
        }
    }

    // MARK: - Buttons
    private var buttonsSection: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .disabled(isSaving)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Button {
                saveCourse()
            } label: {
                if isSaving {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                } else {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(hasChanges ? Color.purple : Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(isSaving || !hasChanges)
        }
    }

    // MARK: - Network Call
    private func saveCourse() {
        isSaving = true
        errorMessage = nil

        let isCreating = course.id == 0
        let endpoint = isCreating
            ? "http://localhost/skillnity/admin_create_course.php"
            : "http://localhost/skillnity/admin_update_course.php"

        guard let url = URL(string: endpoint) else {
            self.errorMessage = "Invalid URL"
            self.showAlert = true
            self.isSaving = false
            return
        }

        var payload: [String: Any] = [
            "id": course.id,
            "title": title,
            "description": description,
            "is_active": isActive ? 1 : 0,
            "image_url": imageURL  // fallback
        ]

        // If image is selected, upload it and get a new image URL
        if let pickedImage = pickedImage {
            uploadImage(pickedImage) { uploadedPath in
                if let path = uploadedPath {
                    payload["image_url"] = path
                    submitCourseData(to: url, payload: payload, isCreating: isCreating)
                } else {
                    self.errorMessage = "Image upload failed"
                    self.showAlert = true
                    self.isSaving = false
                }
            }
        } else {
            submitCourseData(to: url, payload: payload, isCreating: isCreating)
        }
    }

    // MARK: - Upload Image
    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let url = URL(string: "http://localhost/skillnity/upload_image.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        let fieldName = "image"
        let fileName = "course.jpg"

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n")

        request.httpBody = body

        URLSession.shared.uploadTask(with: request, from: body) { data, _, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let path = json["path"] as? String {
                completion(path)
            } else {
                completion(nil)
            }
        }.resume()
    }

    // MARK: - Submit to Server
    private func submitCourseData(to url: URL, payload: [String: Any], isCreating: Bool) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                isSaving = false

                guard error == nil, let data else {
                    errorMessage = error?.localizedDescription ?? "Network error"
                    showAlert = true
                    return
                }

                if let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   result["status"] as? String == "success" {
                    dismiss()
                } else {
                    errorMessage = "Server error: \(String(data: data, encoding: .utf8) ?? "")"
                    showAlert = true
                }
            }
        }.resume()
    }
}

//struct AdminEditCourseView: View {
//    @Environment(\.dismiss) var dismiss
//
//    @State var course: NewCourse
//
//    @State private var title: String
//    @State private var description: String
//    @State private var imageURL: String
//    @State private var isActive: Bool
//
//    // New image picker state
//    @State private var pickedItem: PhotosPickerItem? = nil
//    @State private var pickedImage: UIImage? = nil
//
//    @State private var isSaving = false
//    @State private var errorMessage: String?
//    @State private var showAlert = false
//
//    @ObservedObject private var appState = AppState.shared
//
//    init(course: NewCourse) {
//        self._course = State(initialValue: course)
//        self._title = State(initialValue: course.title)
//        self._description = State(initialValue: course.description)
//        self._imageURL = State(initialValue: course.image_url)
//        self._isActive = State(initialValue: course.is_active == 1)
//    }
//
//    private var hasChanges: Bool {
//        let imageChanged = pickedImage != nil // if user selected a new image
//        return title != course.title ||
//            description != course.description ||
//            isActive != (course.is_active == 1) ||
//            imageChanged
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // MARK: - Thumbnail / Picker
//                ZStack {
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.gray.opacity(0.1))
//                        .frame(height: 140)
//
//                    if let uiImage = pickedImage {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(height: 140)
//                            .clipped()
//                            .cornerRadius(8)
//                    } else if let url = URL(string: "http://localhost/skillnity\(imageURL)") {
//                        AsyncImage(url: url) { phase in
//                            switch phase {
//                            case .empty:
//                                ProgressView()
//                                    .frame(height: 140)
//                            case .success(let image):
//                                image
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(height: 140)
//                                    .clipped()
//                                    .cornerRadius(8)
//                            case .failure:
//                                ZStack {
//                                    Rectangle()
//                                        .fill(Color.gray.opacity(0.1))
//                                    Image(systemName: "photo")
//                                        .font(.largeTitle)
//                                        .foregroundColor(.gray)
//                                }
//                                .frame(height: 140)
//                                .cornerRadius(8)
//                            @unknown default:
//                                EmptyView()
//                            }
//                        }
//                    } else {
//                        Image(systemName: "photo")
//                            .font(.largeTitle)
//                            .foregroundColor(.gray)
//                    }
//
//                    // Overlay to indicate tappable
//                    RoundedRectangle(cornerRadius: 8)
//                        .strokeBorder(Color.themePurple.opacity(0.6), lineWidth: 2)
//                        .frame(height: 140)
//
//                    VStack {
//                        Spacer()
//                        HStack {
//                            Spacer()
//                            Text("Tap to change")
//                                .font(.caption)
//                                .padding(6)
//                                .background(Color.black.opacity(0.6))
//                                .foregroundColor(.white)
//                                .cornerRadius(6)
//                        }
//                    }
//                    .padding(8)
//                }
//                .onTapGesture {
//                    // fallback if user taps outside PhotosPicker
//                }
//
//                PhotosPicker(selection: $pickedItem, matching: .images, photoLibrary: .shared()) {
//                    EmptyView() // invisible wrapper; we use onChange below
//                }
//                .frame(width: 0, height: 0)
//                .onChange(of: pickedItem) { newItem in
//                    guard let newItem else { return }
//                    Task {
//                        if let data = try? await newItem.loadTransferable(type: Data.self),
//                           let uiImage = UIImage(data: data) {
//                            pickedImage = uiImage
//                        }
//                    }
//                }
//
//                // allow user to tap the image area to invoke picker
//                .overlay(
//                    Button(action: {
//                        // trigger PhotosPicker by setting a dummy binding; using .pickerStyle not needed
//                        // Workaround: focus on underlying PhotosPicker - show system picker by presenting a sheet
//                    }) {
//                        Color.clear
//                    }
//                )
//
//                Group {
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Title")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        TextField("Course title", text: $title)
//                            .textFieldStyle(.roundedBorder)
//                    }
//
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Description")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        TextEditor(text: $description)
//                            .frame(minHeight: 100)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                            )
//                    }
//
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Image URL")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        TextField("/uploads/banner.jpg", text: $imageURL)
//                            .textFieldStyle(.roundedBorder)
//                    }
//
//                    Toggle("Active", isOn: $isActive)
//                        .toggleStyle(SwitchToggleStyle(tint: .themePurple))
//                }
//
//                if let errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//
//                HStack {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                    .disabled(isSaving)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(10)
//
//                    Button {
//                        saveChanges()
//                    } label: {
//                        if isSaving {
//                            ProgressView()
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.themePurple)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        } else {
//                            Text("Save")
//                                .bold()
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(hasChanges ? Color.themePurple : Color.gray.opacity(0.5))
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
//                    }
//                    .disabled(isSaving || !hasChanges)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Edit Course")
//        .navigationBarTitleDisplayMode(.inline)
//        .alert("Error", isPresented: $showAlert) {
//            Button("OK", role: .cancel) {}
//        } message: {
//            Text(errorMessage ?? "Unknown error")
//        }
//    }
//
//    private func saveChanges() {
//        isSaving = true
//        errorMessage = nil
//
//        // Prepare payload
//        var payload: [String: Any] = [
//            "id": course.id,
//            "title": title,
//            "description": description,
//            "is_active": isActive ? 1 : 0
//        ]
//
//        // If user picked new image, you’d normally upload it separately and get a path.
//        // For now, if they didn't pick an image, keep existing image_url.
//        payload["image_url"] = pickedImage != nil ? imageURL : imageURL
//
//        guard let url = URL(string: "http://localhost/skillnity/admin_update_course.php") else {
//            self.errorMessage = "Invalid URL"
//            self.showAlert = true
//            self.isSaving = false
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
//        } catch {
//            self.errorMessage = "Failed to encode payload"
//            self.showAlert = true
//            self.isSaving = false
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            DispatchQueue.main.async {
//                self.isSaving = false
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    self.showAlert = true
//                    return
//                }
//
//                guard let data = data else {
//                    self.errorMessage = "No response data"
//                    self.showAlert = true
//                    return
//                }
//
//                do {
//                    if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let status = result["status"] as? String {
//                        if status.lowercased() == "success" {
//                            // reflect updated values locally
//                            let updatedCourse = NewCourse(
//                                id: course.id,
//                                title: title,
//                                description: description,
//                                image_url: imageURL,
//                                is_active: isActive ? 1 : 0,
//                                created_at: course.created_at
//                            )
//                            course = updatedCourse
//                            dismiss()
//                        } else {
//                            self.errorMessage = result["message"] as? String ?? "Update failed"
//                            self.showAlert = true
//                        }
//                    } else {
//                        self.errorMessage = "Unexpected response"
//                        self.showAlert = true
//                    }
//                } catch {
//                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
//                    self.showAlert = true
//                }
//            }
//        }.resume()
//    }
//}

//import SwiftUI
//struct AdminEditCourseView: View {
//    @Environment(\.dismiss) var dismiss
//
//    @State var course: NewCourse
//
//    @State private var title: String
//    @State private var description: String
//    @State private var imageURL: String
//    @State private var isActive: Bool
//    @State private var isSaving = false
//    @State private var errorMessage: String?
//    @State private var showAlert = false
//    @ObservedObject private var appState = AppState.shared
//
//    init(course: NewCourse) {
//        self._course = State(initialValue: course)
//        self._title = State(initialValue: course.title)
//        self._description = State(initialValue: course.description)
//        self._imageURL = State(initialValue: course.image_url)
//        self._isActive = State(initialValue: course.is_active == 1)
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Preview thumbnail
//                if let url = URL(string: "http://localhost/skillnity\(imageURL)") {
//                    AsyncImage(url: url) { phase in
//                        switch phase {
//                        case .empty:
//                            ProgressView().frame(height: 140)
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 140)
//                                .clipped()
//                                .cornerRadius(8)
//                        case .failure:
//                            ZStack {
//                                Rectangle()
//                                    .fill(Color.gray.opacity(0.1))
//                                Image(systemName: "photo")
//                                    .font(.largeTitle)
//                                    .foregroundColor(.gray)
//                            }
//                            .frame(height: 140)
//                            .cornerRadius(8)
//                        @unknown default:
//                            EmptyView()
//                        }
//                    }
//                }
//
//                Group {
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Title")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        TextField("Course title", text: $title)
//                            .textFieldStyle(.roundedBorder)
//                    }
//
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Description")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        TextEditor(text: $description)
//                            .frame(minHeight: 100)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                            )
//                    }
//
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Image URL")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        TextField("/uploads/banner.jpg", text: $imageURL)
//                            .textFieldStyle(.roundedBorder)
//                    }
//
//                    Toggle("Active", isOn: $isActive)
//                        .toggleStyle(SwitchToggleStyle(tint: .themePurple))
//                }
//
//                if let errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//
//                HStack {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                    .disabled(isSaving)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(10)
//
//                    Button {
//                        saveChanges()
//                    } label: {
//                        if isSaving {
//                            ProgressView()
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.themePurple)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        } else {
//                            Text("Save")
//                                .bold()
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.themePurple)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
//                    }
//                    .disabled(isSaving)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Edit Course")
//        .navigationBarTitleDisplayMode(.inline)
//        .alert("Error", isPresented: $showAlert) {
//            Button("OK", role: .cancel) {}
//        } message: {
//            Text(errorMessage ?? "Unknown error")
//        }
//    }
//
//    private func saveChanges() {
//        isSaving = true
//        errorMessage = nil
//
//        let payload: [String: Any] = [
//            "id": course.id,
//            "title": title,
//            "description": description,
//            "image_url": imageURL,
//            "is_active": isActive ? 1 : 0
//        ]
//
//        guard let url = URL(string: "http://localhost/skillnity/admin_update_course.php") else {
//            self.errorMessage = "Invalid URL"
//            self.showAlert = true
//            self.isSaving = false
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
//        } catch {
//            self.errorMessage = "Failed to encode payload"
//            self.showAlert = true
//            self.isSaving = false
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            DispatchQueue.main.async {
//                self.isSaving = false
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    self.showAlert = true
//                    return
//                }
//
//                guard let data = data else {
//                    self.errorMessage = "No response data"
//                    self.showAlert = true
//                    return
//                }
//
//                do {
//                    if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let status = result["status"] as? String {
//                        if status.lowercased() == "success" {
//                            let updatedCourse = NewCourse(
//                                id: course.id,
//                                title: title,
//                                description: description,
//                                image_url: imageURL,
//                                is_active: isActive ? 1 : 0,
//                                created_at: course.created_at
//                            )
//                            course = updatedCourse
//                            dismiss()
//                        } else {
//                            self.errorMessage = result["message"] as? String ?? "Update failed"
//                            self.showAlert = true
//                        }
//                    } else {
//                        self.errorMessage = "Unexpected response"
//                        self.showAlert = true
//                    }
//                } catch {
//                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
//                    self.showAlert = true
//                }
//            }
//        }.resume()
//    }
//}

//import SwiftUI
//
//struct AdminEditCourseView: View {
//    @Environment(\.dismiss) var dismiss
//
//    @State var course: NewCourse
//    @State var currentCourse: NewCourse
//
//    @State private var title: String
//    @State private var description: String
//    @State private var imageURL: String
//    @State private var isActive: Bool
//    @State private var isSaving = false
//    @State private var errorMessage: String?
//    @State private var showAlert = false
//    @ObservedObject private var appState = AppState.shared
//
//    init(course: NewCourse) {
//        self._course = State(initialValue: course)
//        self._title = State(initialValue: course.title)
//        self._description = State(initialValue: course.description)
//        self._imageURL = State(initialValue: course.image_url)
//        self._isActive = State(initialValue: course.is_active == 1)
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Preview thumbnail
//                if let url = URL(string: "http://localhost/skillnity\(imageURL)") {
//                    AsyncImage(url: url) { phase in
//                        switch phase {
//                        case .empty:
//                            ProgressView().frame(height: 140)
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 140)
//                                .clipped()
//                                .cornerRadius(8)
//                        case .failure:
//                            ZStack {
//                                Rectangle()
//                                    .fill(Color.gray.opacity(0.1))
//                                Image(systemName: "photo")
//                                    .font(.largeTitle)
//                                    .foregroundColor(.gray)
//                            }
//                            .frame(height: 140)
//                            .cornerRadius(8)
//                        @unknown default:
//                            EmptyView()
//                        }
//                    }
//                }
//
//                Group {
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Title")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        TextField("Course title", text: $title)
//                            .textFieldStyle(.roundedBorder)
//                    }
//
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Description")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        TextEditor(text: $description)
//                            .frame(minHeight: 100)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                            )
//                    }
//
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("Image URL")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        TextField("/uploads/banner.jpg", text: $imageURL)
//                            .textFieldStyle(.roundedBorder)
//                    }
//
//                    Toggle("Active", isOn: $isActive)
//                        .toggleStyle(SwitchToggleStyle(tint: .themePurple))
//                }
//
//                if let errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//                        .font(.caption)
//                }
//
//                HStack {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                    .disabled(isSaving)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(10)
//
//                    Button {
//                        saveChanges()
//                    } label: {
//                        if isSaving {
//                            ProgressView()
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.themePurple)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        } else {
//                            Text("Save")
//                                .bold()
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.themePurple)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
//                    }
//                    .disabled(isSaving)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Edit Course")
//        .navigationBarTitleDisplayMode(.inline)
//        .alert("Error", isPresented: $showAlert) {
//            Button("OK", role: .cancel) {}
//        } message: {
//            Text(errorMessage ?? "Unknown error")
//        }
//    }
//
//    private func saveChanges() {
//        isSaving = true
//        errorMessage = nil
//
//        let payload: [String: Any] = [
//            "id": course.id,
//            "title": title,
//            "description": description,
//            "image_url": imageURL,
//            "is_active": isActive ? 1 : 0
//        ]
//
//        guard let url = URL(string: "http://localhost/skillnity/admin_update_course.php") else {
//            self.errorMessage = "Invalid URL"
//            self.showAlert = true
//            self.isSaving = false
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
//        } catch {
//            self.errorMessage = "Failed to encode payload"
//            self.showAlert = true
//            self.isSaving = false
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            DispatchQueue.main.async {
//                self.isSaving = false
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    self.showAlert = true
//                    return
//                }
//
//                guard let data = data else {
//                    self.errorMessage = "No response data"
//                    self.showAlert = true
//                    return
//                }
//
//                do {
//                    // parse JSON
//                    if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let status = result["status"] as? String {
//                        if status.lowercased() == "success" {
//                            // reflect updated values locally
//                            let updatedCourse = NewCourse(
//                                id: course.id,
//                                title: title,
//                                description: description,
//                                image_url: imageURL,
//                                is_active: isActive ? 1 : 0,
//                                created_at: course.created_at
//                            )
//                            course = updatedCourse
//                            dismiss()
//                        } else {
//                            self.errorMessage = result["message"] as? String ?? "Update failed"
//                            self.showAlert = true
//                        }
//                    } else {
//                        self.errorMessage = "Unexpected response"
//                        self.showAlert = true
//                    }
//                } catch {
//                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
//                    self.showAlert = true
//                }
//            }
//        }.resume()
//    }
//}
//import SwiftUI

//struct AdminCourseListView: View {
//    @State private var courses: [NewCourse] = []
//    @State private var isLoading = true
//    @State private var errorMessage: String?
//    @ObservedObject private var appState = AppState.shared
//    @State private var showingCreate = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                HStack {
//                    Text("Manage Courses")
//                        .font(.title2.bold())
//                    Spacer()
//                    Button(action: { showingCreate = true }) {
//                        Text("+ Add Course")
//                            .bold()
//                            .padding(8)
//                            .background(Color.themePurple)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top)
//
//                if isLoading {
//                    Spacer()
//                    ProgressView()
//                    Spacer()
//                } else if let error = errorMessage {
//                    Spacer()
//                    Text(error)
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                    Spacer()
//                } else if courses.isEmpty {
//                    Spacer()
//                    Text("No courses available. Add a new course to get started.")
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                    Spacer()
//                } else {
//                    ScrollView {
//                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
//                            ForEach(courses) { course in
//                                NavigationLink(destination: AdminEditCourseView(course: course)) {
//                                    VStack(alignment: .leading, spacing: 8) {
//                                        AsyncImage(url: URL(string: "http://localhost/skillnity\(course.image_url)")) { phase in
//                                            switch phase {
//                                            case .empty:
//                                                ProgressView()
//                                                    .frame(height: 100)
//                                            case .success(let image):
//                                                image
//                                                    .resizable()
//                                                    .scaledToFill()
//                                            case .failure:
//                                                Rectangle()
//                                                    .fill(Color.gray.opacity(0.1))
//                                                    .overlay(Image(systemName: "photo"))
//                                            @unknown default:
//                                                EmptyView()
//                                            }
//                                        }
//                                        .frame(height: 100)
//                                        .clipped()
//                                        .cornerRadius(8)
//
//                                        Text(course.title)
//                                            .font(.headline)
//                                            .lineLimit(1)
//                                        Text(course.description)
//                                            .font(.caption)
//                                            .lineLimit(2)
//                                            .foregroundColor(.gray)
//
//                                        HStack {
//                                            Text(course.is_active == 1 ? "Active" : "Inactive")
//                                                .font(.caption)
//                                                .padding(4)
//                                                .background(course.is_active == 1 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
//                                                .cornerRadius(4)
//                                            Spacer()
//                                        }
//                                    }
//                                    .padding()
//                                    .background(Color.white)
//                                    .cornerRadius(12)
//                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//                                }
//                                .buttonStyle(PlainButtonStyle())
//                            }
//                        }
//                        .padding()
//                    }
//                    .refreshable {
//                        loadCourses()
//                    }
//                }
//            }
//            .background(Color(.systemGroupedBackground).ignoresSafeArea())
//            .navigationTitle("Courses")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: { loadCourses() }) {
//                        Image(systemName: "arrow.clockwise")
//                    }
//                }
//            }
//            .sheet(isPresented: $showingCreate) {
//                // Either a dedicated create view, or reuse edit with empty/new marker
//                AdminCreateCourseView { created in
//                    showingCreate = false
//                    if created {
//                        loadCourses()
//                    }
//                }
//            }
//            .onAppear(perform: loadCourses)
//        }
//    }
//
//    private func loadCourses() {
//        isLoading = true
//        errorMessage = nil
//        APIService.shared.fetchNewCourses { result in
//            DispatchQueue.main.async {
//                isLoading = false
//                switch result {
//                case .success(let all):
//                    self.courses = all // or filter if needed
//                case .failure(let err):
//                    self.errorMessage = err.localizedDescription
//                }
//            }
//        }
//    }
//}
