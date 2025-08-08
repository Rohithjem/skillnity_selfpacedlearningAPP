//
//import Foundation
//import SwiftUI
//
//struct RoadmapSelectionView: View {
//    @ObservedObject private var appState = AppState.shared
//    @State private var showDSARoadmap = false
//    @State private var newCourses: [NewCourse] = []
//    @State private var isLoading = true
//    @State private var errorMessage: String?
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 24) {
//                // Header
//                VStack(spacing: 4) {
//                    Text("Your Learning Roadmaps")
//                        .font(.title2.bold())
//                        .foregroundColor(.black)
//
//                    Text("Choose your path to success")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//                .padding(.top)
//
//                // DSA Roadmap Card
//                NavigationLink(destination: DSARoadmapView()) {
//                    HStack {
//                        VStack(alignment: .leading, spacing: 6) {
//                            Text("DSA Roadmap")
//                                .font(.headline)
//                                .foregroundColor(.black)
//                            Text("Master Data Structures & Algorithms in 5 weeks")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        Spacer()
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(.themePurple)
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .shadow(color: .gray.opacity(0.05), radius: 2, x: 0, y: 1)
//                }
//                .padding(.horizontal)
//
//                // New Courses Section
//                if isLoading {
//                    ProgressView()
//                        .padding(.top)
//                } else if let error = errorMessage {
//                    Text(error)
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                } else if newCourses.isEmpty {
//                    Text("No additional roadmaps available yet.")
//                        .foregroundColor(.gray)
//                        .padding(.horizontal)
//                } else {
//                    // Horizontal scroll of new course roadmaps
//                    Text("Other Roadmaps")
//                        .font(.title3.bold())
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.horizontal)
//
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 16) {
//                            ForEach(newCourses) { course in
//                                NavigationLink(destination: CourseDetailView(course: course)) {
//                                    VStack(alignment: .leading, spacing: 8) {
//                                        AsyncImage(url: URL(string: "http://localhost/skillnity\(course.thumbnail)")) { phase in
//                                            switch phase {
//                                            case .empty:
//                                                ZStack {
//                                                    Rectangle()
//                                                        .fill(Color.gray.opacity(0.1))
//                                                    ProgressView()
//                                                }
//                                            case .success(let image):
//                                                image
//                                                    .resizable()
//                                                    .scaledToFill()
//                                            case .failure:
//                                                ZStack {
//                                                    Rectangle()
//                                                        .fill(Color.gray.opacity(0.1))
//                                                    Image(systemName: "photo")
//                                                        .foregroundColor(.gray)
//                                                }
//                                            @unknown default:
//                                                EmptyView()
//                                            }
//                                        }
//                                        .frame(width: 180, height: 100)
//                                        .clipped()
//                                        .cornerRadius(8)
//
//                                        Text(course.title)
//                                            .font(.headline)
//                                            .foregroundColor(.black)
//                                            .lineLimit(1)
//
//                                        Text(course.description)
//                                            .font(.caption)
//                                            .foregroundColor(.gray)
//                                            .lineLimit(2)
//
//                                        if appState.isAdmin {
//                                            HStack {
//                                                Spacer()
//                                                NavigationLink(destination: AdminEditCourseView(course: course)) {
//                                                    Text("Edit")
//                                                        .font(.caption)
//                                                        .padding(6)
//                                                        .background(Color.themePurple.opacity(0.1))
//                                                        .foregroundColor(.themePurple)
//                                                        .cornerRadius(6)
//                                                }
//                                            }
//                                        }
//                                    }
//                                    .padding()
//                                    .frame(width: 180)
//                                    .background(Color.white)
//                                    .cornerRadius(12)
//                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//                                }
//                                .buttonStyle(PlainButtonStyle())
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//
//                // Coming Soon
//                VStack(spacing: 12) {
//                    ForEach(["Frontend Roadmap", "Backend Roadmap", "AI/ML Roadmap"], id: \.self) { title in
//                        HStack {
//                            VStack(alignment: .leading, spacing: 6) {
//                                Text(title)
//                                    .font(.headline)
//                                Text("Coming soon...")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            Spacer()
//                            Image(systemName: "clock")
//                                .foregroundColor(.gray)
//                        }
//                        .padding()
//                        .background(Color.gray.opacity(0.05))
//                        .cornerRadius(12)
//                        .padding(.horizontal)
//                    }
//                }
//                .padding(.top)
//            }
//        }
//        .background(Color.white.ignoresSafeArea())
//        .navigationTitle("Roadmap")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            fetchNewCourses()
//        }
//        final class APIService {
//            static let shared = APIService()
//
//            // adjust to match your actual server address
//            private let baseURL = "http://localhost/skillnity"
//
//            private init() {}
//
//            // Fetch new courses
//            func fetchNewCourses(completion: @escaping (Result<[NewCourse], Error>) -> Void) {
//                guard let url = URL(string: "\(baseURL)/get_courses.php") else {
//                    completion(.failure(APIError.invalidURL))
//                    return
//                }
//
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    if let error = error {
//                        completion(.failure(error))
//                        return
//                    }
//
//                    guard let data = data else {
//                        completion(.failure(APIError.invalidResponse))
//                        return
//                    }
//
//                    do {
//                        let courses = try JSONDecoder().decode([NewCourse].self, from: data)
//                        completion(.success(courses))
//                    } catch {
//                        completion(.failure(error))
//                    }
//                }.resume()
//            }
//
//            // Example other method signatures you already had
//            func fetchProgress(userID: Int, completion: @escaping (Result<ProgressData, Error>) -> Void) {
//                // implement similar pattern...
//            }
//
//            func updateProgress(userID: Int, quizzesPassed: Int, badgesEarned: Int, week: Int, completion: @escaping (Bool) -> Void) {
//                guard let url = URL(string: "\(baseURL)/update_progress.php") else {
//                    completion(false); return
//                }
//
//                let parameters: [String: Any] = [
//                    "user_id": userID,
//                    "quizzes_passed": quizzesPassed,
//                    "badges_earned": badgesEarned,
//                    "week": week
//                ]
//
//                var request = URLRequest(url: url)
//                request.httpMethod = "POST"
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                do {
//                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//                } catch {
//                    completion(false); return
//                }
//
//                URLSession.shared.dataTask(with: request) { data, _, error in
//                    guard let data = data, error == nil else {
//                        completion(false); return
//                    }
//                    do {
//                        let result = try JSONDecoder().decode([String: String].self, from: data)
//                        completion(result["status"] == "success")
//                    } catch {
//                        completion(false)
//                    }
//                }.resume()
//            }
//            private func loadCourses() {
//                APIService.shared.fetchNewCourses { result in
//                    DispatchQueue.main.async {
//                        switch result {
//                        case .success(let courses):
//                            self.newCourses = courses
//                        case .failure(let error):
//                            print("Failed to load courses: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//    }
//    enum APIError: Error, LocalizedError {
//        case invalidURL
//        case noData
//        case decodingError
//        case custom(String)
//        case invalidResponse
//
//        var errorDescription: String? {
//            switch self {
//            case .invalidURL: return "Invalid URL."
//            case .noData: return "No data received."
//            case .decodingError: return "Failed to decode response."
//            case .invalidResponse: return "Invalid server response."
//            case .custom(let message): return message
//            }
//        }
//    }
//
//
//    
//
//    }
//
//
//}
//
//// Placeholder admin edit view you can implement
//struct AdminEditCourseView: View {
//    let course: NewCourse
//
//    var body: some View {
//        Text("Edit \(course.title)")
//            .navigationTitle("Edit Course")
//    }
//}

////loadCourses()
////
////APIService.shared.fetchNewCourses { result in
////    switch result {
////    case .success(let fetchedCourses):
////        DispatchQueue.main.async {
////            self.newCourses = fetchedCourses
////        }
////    case .failure(let error):
////        print("Error fetching courses:", error.localizedDescription)
////    }
////}
////func loadCourses() {
////    APIService.shared.fetchNewCourses { result in
////        DispatchQueue.main.async {
////            switch result {
////            case .success(let courses):
////                self.newCourses = courses
////            case .failure(let error):
////                print("Failed to load courses: \(error)")
////            }
////        }
////    }
////}
////    private func fetchNewCourses() {
////        isLoading = true
////        errorMessage = nil
////        APIService.shared.fetchNewCourses { result in
////            DispatchQueue.main.async {
////                switch result {
////                case .success(let courses):
////                    self.newCourses = courses
////                case .failure(let error):
////                    self.errorMessage = "Failed to load roadmaps: \(error.localizedDescription)"
////                }
////                self.isLoading = false
////            }
////        }
////    }
////    func fetchNewCourses(completion: @escaping (Result<[NewCourse], Error>) -> Void) {
////        guard let url = URL(string: "\(baseURL)/get_courses.php") else {
////            completion(.failure(APIError.invalidURL))
////            return
////        }
////
////        URLSession.shared.dataTask(with: url) { data, response, error in
////            if let error = error {
////                completion(.failure(error))
////                return
////            }
////
////            guard let data = data else {
////                completion(.failure(APIError.invalidResponse))
////                return
////            }
////
////            do {
////                let courses = try JSONDecoder().decode([NewCourse].self, from: data)
////                completion(.success(courses))
////            } catch {
////                completion(.failure(error))
////            }
////        }.resume()
////    }
import SwiftUI

// MARK: - Models

struct NewCourse: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let image_url: String
    let is_active: Int
    let created_at: String

    // Coding keys to map JSON strings to correct types
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case image_url
        case is_active
        case created_at
    }

    // Custom decoder to tolerate numeric values as strings
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let idStr = try? container.decode(String.self, forKey: .id), let idInt = Int(idStr) {
            self.id = idInt
        } else {
            self.id = try container.decode(Int.self, forKey: .id)
        }

        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.image_url = try container.decode(String.self, forKey: .image_url)

        if let activeStr = try? container.decode(String.self, forKey: .is_active), let activeInt = Int(activeStr) {
            self.is_active = activeInt
        } else {
            self.is_active = try container.decode(Int.self, forKey: .is_active)
        }

        self.created_at = try container.decode(String.self, forKey: .created_at)
    }

    // Explicit initializer so you can build instances in code
    init(id: Int, title: String, description: String, image_url: String, is_active: Int, created_at: String) {
        self.id = id
        self.title = title
        self.description = description
        self.image_url = image_url
        self.is_active = is_active
        self.created_at = created_at
    }
}


// MARK: - API Layer

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case custom(String)
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No data received."
        case .decodingError: return "Failed to decode response."
        case .invalidResponse: return "Invalid server response."
        case .custom(let message): return message
        }
    }
}

final class APIServicee {
    static let shared = APIService()
    private let baseURL = "http://localhost/skillnity"

    private init() {}

    func fetchNewCourses(completion: @escaping (Result<[NewCourse], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/get_courses.php") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let courses = try JSONDecoder().decode([NewCourse].self, from: data)
                completion(.success(courses))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }.resume()
    }

    // You can add other methods like fetchProgress/updateProgress here as needed.
}

// MARK: - View

struct RoadmapSelectionView: View {
    @ObservedObject private var appState = AppState.shared
    @State private var newCourses: [NewCourse] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 4) {
                    Text("Your Learning Roadmaps")
                        .font(.title2.bold())
                        .foregroundColor(.black)

                    Text("Choose your path to success")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                // DSA Roadmap Card
                NavigationLink(destination: DSARoadmapView()) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("DSA Roadmap")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("Master Data Structures & Algorithms in 5 weeks")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.themePurple)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                .padding(.horizontal)

                // New Courses Section
                Group {
                    if isLoading {
                        ProgressView()
                            .padding(.top)
                    } else if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    } else if newCourses.isEmpty {
                        Text("No additional roadmaps available yet.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        Text("Other Roadmaps")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(newCourses) { course in
                                    NavigationLink(destination: CourseDetailView(course: course)) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            AsyncImage(url: URL(string: "http://localhost/skillnity\(course.image_url)")) { phase in
                                                switch phase {
                                                case .empty:
                                                    ZStack {
                                                        Rectangle()
                                                            .fill(Color.gray.opacity(0.1))
                                                        ProgressView()
                                                    }
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                case .failure:
                                                    ZStack {
                                                        Rectangle()
                                                            .fill(Color.gray.opacity(0.1))
                                                        Image(systemName: "photo")
                                                            .foregroundColor(.gray)
                                                    }
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .frame(width: 180, height: 100)
                                            .clipped()
                                            .cornerRadius(8)

                                            Text(course.title)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                                .lineLimit(1)

                                            Text(course.description)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .lineLimit(2)

                                            if appState.isAdmin {
                                                HStack {
                                                    Spacer()
                                                    NavigationLink(destination: AdminEditCourseView(course: course)) {
                                                        Text("Edit")
                                                            .font(.caption)
                                                            .padding(6)
                                                            .background(Color.themePurple.opacity(0.1))
                                                            .foregroundColor(.themePurple)
                                                            .cornerRadius(6)
                                                    }
                                                }
                                            }
                                        }
                                        .padding()
                                        .frame(width: 180)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // Coming Soon
                VStack(spacing: 12) {
                    ForEach(["Frontend Roadmap", "Backend Roadmap", "AI/ML Roadmap"], id: \.self) { title in
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(title)
                                    .font(.headline)
                                Text("Coming soon...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("Roadmap")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadNewCourses()
        }
    }

    private func loadNewCourses() {
        isLoading = true
        errorMessage = nil
        APIServicee.shared.fetchNewCourses { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let courses):
                    // Filter active if needed
                    self.newCourses = courses.filter { $0.is_active == 1 }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
