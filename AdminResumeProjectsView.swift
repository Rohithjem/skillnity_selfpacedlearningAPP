//
//  AdminResumeProjectsView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 04/08/25.
//

import SwiftUI

struct AdminResumeProjectsView: View {
    @State private var projects: [ResumeProject] = []
    @State private var showEditView = false
    @State private var selectedProject: ResumeProject? = nil
    @State private var showDeleteConfirmation = false
    @State private var projectToDelete: ResumeProject? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    ForEach(projects) { project in
                        projectCard(project)
                    }

                    Button(action: {
                        selectedProject = nil
                        showEditView = true
                    }) {
                        Label("Add New Project", systemImage: "plus")
                            .font(.callout)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.themePurple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                .padding(.top)
            }
            .background(Color.white.ignoresSafeArea())
            .onAppear(perform: fetchProjects)
            .sheet(isPresented: $showEditView, onDismiss: fetchProjects) {
                AdminEditProjectView(project: selectedProject)
            }
            .alert("Delete Project", isPresented: $showDeleteConfirmation, presenting: projectToDelete) { project in
                Button("Delete", role: .destructive) {
                    deleteProject(id: project.id)
                }
                Button("Cancel", role: .cancel) { }
            } message: { project in
                Text("Are you sure you want to delete “\(project.title)”?")
            }
        }
    }

    var header: some View {
        VStack(spacing: 4) {
            Text("Manage Resume Projects")
                .font(.title2.bold())
                .foregroundColor(.black)

            Text("Add, Edit or Delete Projects")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }

    func projectCard(_ project: ResumeProject) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(project.title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: iconName(for: project.icon_name))
                    .foregroundColor(.themePurple)
            }

            Text(project.type)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.themePurple.opacity(0.1))
                .foregroundColor(.themePurple)
                .clipShape(Capsule())

            Text(project.short_description)
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Button("Edit") {
                    selectedProject = project
                    showEditView = true
                }
                .font(.callout)
                .padding(8)
                .background(Color.themePurple.opacity(0.1))
                .cornerRadius(8)

                Button("Delete") {
                    projectToDelete = project
                    showDeleteConfirmation = true
                }
                .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }

    func fetchProjects() {
        guard let url = URL(string: "http://localhost/skillnity/get_resume_projects.php") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode([ResumeProject].self, from: data)
                DispatchQueue.main.async {
                    self.projects = decoded
                }
            } catch {
                print("❌ Failed to decode resume projects: \(error)")
                if let raw = String(data: data, encoding: .utf8) {
                    print("⚠️ Raw response: \(raw)")
                }
            }
        }.resume()
    }

    func deleteProject(id: Int) {
        guard let url = URL(string: "http://localhost/skillnity/admin_delete_resume_project.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["id": id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("✅ Delete response:", json)
                    DispatchQueue.main.async {
                        fetchProjects() // Refresh list
                    }
                }
            }
        }.resume()
    }

    func iconName(for key: String?) -> String {
        switch key {
        case "code": return "chevron.left.slash.chevron.right"
        case "server": return "server.rack"
        case "cloud": return "cloud"
        default: return "cube.box"
        }
    }
}


//struct AdminResumeProjectsView: View {
//    @State private var projects: [ResumeProject] = []
//    @State private var showEditView = false
//    @State private var selectedProject: ResumeProject? = nil
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 24) {
//                    VStack(spacing: 4) {
//                        Text("Manage Resume Projects")
//                            .font(.title2.bold())
//                            .foregroundColor(.black)
//
//                        Text("Add, Edit or Delete Projects")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.top)
//
//                    ForEach(projects) { project in
//                        VStack(alignment: .leading, spacing: 10) {
//                            HStack {
//                                Text(project.title)
//                                    .font(.headline)
//                                    .foregroundColor(.black)
//                                Spacer()
//                                Image(systemName: iconName(for: project.icon_name))
//                                    .foregroundColor(.themePurple)
//                            }
//
//                            Text(project.type)
//                                .font(.caption)
//                                .padding(.horizontal, 8)
//                                .padding(.vertical, 4)
//                                .background(Color.themePurple.opacity(0.1))
//                                .foregroundColor(.themePurple)
//                                .clipShape(Capsule())
//
//                            Text(project.short_description)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//
//                            HStack {
//                                Button("Edit") {
//                                    selectedProject = project
//                                    showEditView = true
//                                }
//                                .font(.callout)
//                                .padding(8)
//                                .background(Color.themePurple.opacity(0.1))
//                                .cornerRadius(8)
//
//                                Button("Delete") {
//                                    deleteProject(id: project.id)
//                                }
//                                .foregroundColor(.red)
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: .gray.opacity(0.05), radius: 2, x: 0, y: 1)
//                        .padding(.horizontal)
//                    }
//
//                    Button(action: {
//                        selectedProject = nil
//                        showEditView = true
//                    }) {
//                        Label("Add New Project", systemImage: "plus")
//                            .font(.callout)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.themePurple)
//                            .foregroundColor(.white)
//                            .cornerRadius(12)
//                            .padding(.horizontal)
//                    }
//                    .padding(.bottom)
//                }
//            }
//            .background(Color.white.ignoresSafeArea())
//            .onAppear { fetchProjects() }
//            .sheet(isPresented: $showEditView, onDismiss: fetchProjects) {
//                AdminEditProjectView(project: selectedProject)
//            }
//        }
//    }
//
//    func fetchProjects() {
//        guard let url = URL(string: "http://localhost/skillnity/get_resume_projects.php") else { return }
//
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            guard let data = data else { return }
//            do {
//                let decoded = try JSONDecoder().decode([ResumeProject].self, from: data)
//                DispatchQueue.main.async {
//                    self.projects = decoded
//                }
//            } catch {
//                print("❌ Fetch error: \(error)")
//            }
//        }.resume()
//    }
//
//    func deleteProject(id: Int) {
//        guard let url = URL(string: "http://localhost/skillnity/delete_resume_project.php?id=\(id)") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//
//        URLSession.shared.dataTask(with: request) { _, _, _ in
//            DispatchQueue.main.async {
//                self.projects.removeAll { $0.id == id }
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
