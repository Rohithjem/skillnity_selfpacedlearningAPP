import SwiftUI

import SwiftUI

import SwiftUI
import AVKit

struct CourseDetailView: View {
    let course: NewCourse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Banner / Thumbnail
                AsyncImage(url: URL(string: "http://localhost/skillnity\(course.image_url)")) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Rectangle().fill(Color.gray.opacity(0.1))
                            ProgressView()
                        }
                        .frame(height: 220)
                        .cornerRadius(12)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 220)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        ZStack {
                            Rectangle().fill(Color.gray.opacity(0.1))
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                        .frame(height: 220)
                        .cornerRadius(12)
                    @unknown default:
                        EmptyView()
                    }
                }

                // Title & Description
                Text(course.title)
                    .font(.title.bold())
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)

                Text(course.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()

                // Video Lectures Section
//                SectionHeader(title: "Video Lectures", subtitle: "Watch the recorded lessons")
//                VStack(spacing: 12) {
//                    // For now placeholder list; replace with dynamic video URLs when backend supports it
//                    ForEach(1...3, id: \.self) { idx in
//                        NavigationLink(destination: VideoPlayerView(videoName: "sample_video")) {
//                            HStack(spacing: 12) {
//                                Image(systemName: "play.circle.fill")
//                                    .font(.title2)
//                                    .foregroundColor(.themePurple)
//                                VStack(alignment: .leading) {
//                                    Text("Lecture \(idx)")
//                                        .font(.headline)
//                                        .foregroundColor(.black)
//                                    Text("Introduction and overview")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
//                            }
//                            .padding()
//                            .background(Color(.systemGray6))
//                            .cornerRadius(10)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                }

                Divider()

                // PDF Resources
                SectionHeader(title: "PDF Resources", subtitle: "Downloadable materials")
                VStack(spacing: 12) {
                    ForEach(1...2, id: \.self) { idx in
                        Button(action: {
                            // TODO: open appropriate PDF
                        }) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.themePurple)
                                Text("Resource \(idx)")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "arrow.down.circle")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Divider()

                // Quiz Section
                SectionHeader(title: "Quiz", subtitle: "Test your knowledge")
                VStack(spacing: 12) {
                    Text("Complete the quiz to unlock badges and track your progress.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Button(action: {
                        // navigate to the course-specific quiz
                    }) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("Start Quiz")
                                .bold()
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.themePurple)
                        .cornerRadius(12)
                    }
                }

                Divider()

                // Additional Info (placeholder for future expansions)
                Text("What You'll Learn")
                    .font(.headline)
                    .foregroundColor(.black)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checkmark.seal")
                            .foregroundColor(.themePurple)
                        Text("Core concepts of \(course.title)")
                    }
                    HStack {
                        Image(systemName: "checkmark.seal")
                            .foregroundColor(.themePurple)
                        Text("Hands-on examples")
                    }
                    HStack {
                        Image(systemName: "checkmark.seal")
                            .foregroundColor(.themePurple)
                        Text("Quiz & certification")
                    }
                }
                .font(.subheadline)

                Spacer(minLength: 30)
            }
            .padding()
        }
        .background(Color.white)
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

fileprivate struct SectionHeader: View {
    let title: String
    let subtitle: String?

    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.themePurple)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
