import SwiftUI

struct ResumeProjectsView: View {
    @State private var projects: [ResumeProject] = []
    @State private var selectedProject: ResumeProject? = nil
    @State private var showDetails = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title & Subtitle
                    VStack(spacing: 4) {
                        Text("Resume-Built Projects")
                            .font(.title2.bold())
                            .foregroundColor(.black)

                        Text("Handpicked by Industry Experts")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top)

                    // Cards
                    ForEach(projects) { project in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(project.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: iconName(for: project.icon_name ?? "questionmark"))

                                    .foregroundColor(.themePurple)
                            }

                            Text(project.type)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.themePurple.opacity(0.1))
                                .foregroundColor(.themePurple)
                                .clipShape(Capsule())

                            Text(project.short_description)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Button(action: {
                                withAnimation {
                                    selectedProject = project
                                    showDetails = true
                                }
                            }) {
                                HStack {
                                    Text("View Details")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.callout)
                                .foregroundColor(.themePurple)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.themePurple))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .gray.opacity(0.05), radius: 2, x: 0, y: 1)
                        .padding(.horizontal)
                    }

                    // Footer Quote
                    Text("“Projects speak louder than words!”")
                        .font(.footnote)
                        .foregroundColor(.themePurple)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.themePurple.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                }
            }
            .background(Color.white.ignoresSafeArea())
            .onAppear {
                fetchProjects()
            }
            .sheet(isPresented: $showDetails) {
                if let project = selectedProject {
                    ProjectDetailView(project: project)
                }
            }
        }
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
                print("❌ JSON Decode Error: \(error)")
            }
        }.resume()
    }

    func iconName(for key: String) -> String {
        switch key {
        case "code": return "chevron.left.slash.chevron.right"
        case "server": return "server.rack"
        case "cloud": return "cloud"
        default: return "cube.box"
        }
    }
}
