import SwiftUI

struct ProjectDetailView: View {
    let project: ResumeProject
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title + Icon
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: iconName(for: project.icon_name ?? "questionmark"))

                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.themePurple)

                        Text(project.title)
                            .font(.title2.bold())
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }

                    // Category Capsule
                    Text(project.type)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.themePurple.opacity(0.15))
                        .foregroundColor(.themePurple)
                        .clipShape(Capsule())

                    Divider()

                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.black)

                        if let description = try? AttributedString(markdown: project.full_description) {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.gray)
                        } else {
                            Text(project.full_description)
                                .font(.body)
                                .foregroundColor(.gray)
                        }

                    }

                    // Technologies (optional)
//                    if let tech = project.technologies, !tech.isEmpty {
//                        Divider()
//
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Technologies Used")
//                                .font(.headline)
//                                .foregroundColor(.black)
//
//                            Text(tech)
//                                .font(.body)
//                                .foregroundColor(.black)
//                        }
//                    }

                    // Tips (optional)
//                    if let tips = project.tips, !tips.isEmpty {
//                        Divider()
//
//                        VStack(alignment: .leading, spacing: 8) {
//                            Text("Expert Tips")
//                                .font(.headline)
//                                .foregroundColor(.black)
//
//                            Text(tips)
//                                .font(.body)
//                                .foregroundColor(.black)
//                        }
//                    }

                    Spacer(minLength: 30)
                }
                .padding()
            }
            .navigationTitle("Project Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.themePurple)
                            .imageScale(.large)
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
        }
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
