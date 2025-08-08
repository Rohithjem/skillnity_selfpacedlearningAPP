//
//  AdminEditProjectView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 04/08/25.
//

import Foundation
import SwiftUI
struct AdminEditProjectView: View {
    @Environment(\.dismiss) private var dismiss
    var project: ResumeProject?

    @State private var title = ""
    @State private var type = "Frontend"
    @State private var shortDescription = ""
    @State private var fullDescription = ""
    @State private var iconName = "code"

    let types = ["Frontend", "Backend", "Full Stack"]
    let icons = ["code", "server", "cloud"]

    var isNewProject: Bool { project == nil }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Title", text: $title)

                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) { Text($0) }
                    }

                    TextField("Short Description", text: $shortDescription)

                    TextEditor(text: $fullDescription)
                        .frame(minHeight: 100)
                }

                Section(header: Text("Icon Name")) {
                    Picker("Icon", selection: $iconName) {
                        ForEach(icons, id: \.self) { name in
                            Label(name.capitalized, systemImage: iconNameForPreview(name))
                        }
                    }
                }

                Button(action: saveProject) {
                    Text(isNewProject ? "Add Project" : "Update Project")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.themePurple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .navigationTitle(isNewProject ? "New Project" : "Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: setupForm)
        }
    }

    func setupForm() {
        if let project = project {
            title = project.title
            type = project.type
            shortDescription = project.short_description
            fullDescription = project.full_description
            iconName = project.icon_name ?? "code"
        }
    }

    func saveProject() {
        let urlString = isNewProject ?
            "http://localhost/skillnity/admin_create_resume_project.php" :
            "http://localhost/skillnity/admin_update_resume_project.php"

        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        if isNewProject {
            // 🔹 Send JSON for project creation
            let body: [String: Any] = [
                "title": title,
                "type": type,
                "short_description": shortDescription,
                "full_description": fullDescription,
                "icon_name": iconName
            ]

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        } else {
            // 🔹 Send URL-encoded for update
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "id", value: "\(project?.id ?? 0)"),
                URLQueryItem(name: "title", value: title),
                URLQueryItem(name: "type", value: type),
                URLQueryItem(name: "short_description", value: shortDescription),
                URLQueryItem(name: "full_description", value: fullDescription),
                URLQueryItem(name: "icon_name", value: iconName)
            ]
            request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
        }

        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                dismiss()
            }
        }.resume()
    }


    func iconNameForPreview(_ key: String) -> String {
        switch key {
        case "code": return "chevron.left.slash.chevron.right"
        case "server": return "server.rack"
        case "cloud": return "cloud"
        default: return "cube.box"
        }
    }
}


//struct AdminEditProjectView: View {
//    @Environment(\.dismiss) private var dismiss
//    var project: ResumeProject?
//
//    @State private var title = ""
//    @State private var type = "Frontend"
//    @State private var shortDescription = ""
//    @State private var fullDescription = ""
//    @State private var iconName = "code"
//
//    let types = ["Frontend", "Backend", "Full Stack"]
//    let icons = ["code", "server", "cloud"]
//
//    var isNewProject: Bool { project == nil }
//
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("Project Details")) {
//                    TextField("Title", text: $title)
//
//                    Picker("Type", selection: $type) {
//                        ForEach(types, id: \.self, content: Text.init)
//                    }
//
//                    TextField("Short Description", text: $shortDescription)
//                    TextEditor(text: $fullDescription)
//                        .frame(minHeight: 100)
//                }
//
//                Section(header: Text("Icon Name")) {
//                    Picker("Icon", selection: $iconName) {
//                        ForEach(icons, id: \.self) { name in
//                            Label(name.capitalized, systemImage: iconName(for: name))
//                        }
//                    }
//                }
//
//                Button(action: saveProject) {
//                    Text(isNewProject ? "Add Project" : "Update Project")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.themePurple)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//            }
//            .navigationTitle(isNewProject ? "New Project" : "Edit Project")
//            .navigationBarTitleDisplayMode(.inline)
//            .onAppear(perform: setupForm)
//        }
//    }
//
//    func setupForm() {
//        if let project = project {
//            title = project.title
//            type = project.type
//            shortDescription = project.short_description
//            fullDescription = project.full_description
//            iconName = project.icon_name ?? "code"
//        }
//    }
//
//    func saveProject() {
//        let urlString = isNewProject ?
//            "http://localhost/skillnity/create_resume_project.php" :
//            "http://localhost/skillnity/update_resume_project.php"
//
//        guard let url = URL(string: urlString) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        var components = URLComponents()
//        components.queryItems = [
//            URLQueryItem(name: "title", value: title),
//            URLQueryItem(name: "type", value: type),
//            URLQueryItem(name: "short_description", value: shortDescription),
//            URLQueryItem(name: "full_description", value: fullDescription),
//            URLQueryItem(name: "icon_name", value: iconName)
//        ]
//
//        if let id = project?.id {
//            components.queryItems?.append(URLQueryItem(name: "id", value: "\(id)"))
//        }
//        if let id = project?.id {
//            print("✅ Updating project with id: \(id)")
//        } else {
//            print("⚠️ No ID found – creating new project")
//        }
//
//
//
//        request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
//
//        URLSession.shared.dataTask(with: request) { data, _, _ in
//            DispatchQueue.main.async {
//                dismiss()
//            }
//        }.resume()
//    }
//
//    func iconName(for key: String) -> String {
//        switch key {
//        case "code": return "chevron.left.slash.chevron.right"
//        case "server": return "server.rack"
//        case "cloud": return "cloud"
//        default: return "cube.box"
//        }
//    }
//}

//import SwiftUI
//struct AdminEditProjectView: View {
//    @Environment(\.dismiss) private var dismiss
//    var project: ResumeProject?
//
//    @State private var title = ""
//    @State private var type = "Frontend"
//    @State private var shortDescription = ""
//    @State private var fullDescription = ""
//    @State private var iconName = "code"
//
//    let types = ["Frontend", "Backend", "Full Stack"]
//    let icons = ["code", "server", "cloud"]
//
//    var isNewProject: Bool { project == nil }
//
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("Project Details")) {
//                    TextField("Title", text: $title)
//
//                    Picker("Type", selection: $type) {
//                        ForEach(types, id: \.self) { Text($0) }
//                    }
//
//                    TextField("Short Description", text: $shortDescription)
//                    TextEditor(text: $fullDescription)
//                        .frame(minHeight: 100)
//                }
//
//                Section(header: Text("Icon Name")) {
//                    Picker("Icon", selection: $iconName) {
//                        ForEach(icons, id: \.self) { name in
//                            Label(name.capitalized, systemImage: iconName(for: name))
//                        }
//                    }
//                }
//
//                Button(action: saveProject) {
//                    Text(isNewProject ? "Add Project" : "Update Project")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.themePurple)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//            }
//            .navigationTitle(isNewProject ? "New Project" : "Edit Project")
//            .navigationBarTitleDisplayMode(.inline)
//            .onAppear { setupForm() }
//        }
//    }
//
//    func setupForm() {
//        if let project = project {
//            title = project.title
//            type = project.type
//            shortDescription = project.short_description
//            fullDescription = project.full_description
//            iconName = project.icon_name ?? "code"
//        }
//    }
//
//    func saveProject() {
//        let urlString = isNewProject ?
//            "http://localhost/skillnity/create_resume_project.php" :
//            "http://localhost/skillnity/update_resume_project.php"
//
//        guard let url = URL(string: urlString) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        var components = URLComponents()
//        components.queryItems = [
//            URLQueryItem(name: "title", value: title),
//            URLQueryItem(name: "type", value: type),
//            URLQueryItem(name: "short_description", value: shortDescription),
//            URLQueryItem(name: "full_description", value: fullDescription),
//            URLQueryItem(name: "icon_name", value: iconName)
//        ]
//
//        if let id = project?.id {
//            components.queryItems?.append(URLQueryItem(name: "id", value: "\(id)"))
//        }
//
//        request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
//
//        URLSession.shared.dataTask(with: request) { _, _, _ in
//            DispatchQueue.main.async {
//                dismiss()
//            }
//        }.resume()
//    }
//
//    func iconName(for key: String) -> String {
//        switch key {
//        case "code": return "chevron.left.slash.chevron.right"
//        case "server": return "server.rack"
//        case "cloud": return "cloud"
//        default: return "cube.box"
//        }
//    }
//}
