import Foundation

class APIService {
    static let shared = APIService()

    private let baseURL = "http://localhost/skillnity"

//    enum APIError: Error {
//            case invalidURL
//            case noData
//
//        }


    // MARK: - Fetch User Info
//    func fetchUser(userID: Int, completion: @escaping (Result<User, Error>) -> Void) {
//        guard let url = URL(string: "\(baseURL)/get_user_data.php?user_id=\(userID)") else {
//            print("❌ Invalid URL for fetchUser")
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        print("🔄 Fetching user: \(url.absoluteString)")
//        fetchWrapped(url: url, completion: completion)
//    }
    struct UserResponse: Codable {
        let data: User
    }


    func fetchUser(userID: Int, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/get_user_data.php?user_id=\(userID)") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(WrappedResponse<User>.self, from: data)
                if let user = decoded.data {
                    completion(.success(user))
                } else {
                    let msg = decoded.message ?? "No user data"
                    completion(.failure(APIError.backend(msg)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

//    func fetchadmin(userID: Int, completion: @escaping (Result<User, Error>) -> Void) {
//        guard let url = URL(string: "\(baseURL)/get_admin_data.php?user_id=\(userID)") else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(APIError.noData))
//                return
//            }
//
//            do {
//                let decoded = try JSONDecoder().decode(WrappedResponse<User>.self, from: data)
//
//                completion(.success(decoded.data)) // ✅ Correct field
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }

        func fetchAdminUser(userID: Int, completion: @escaping (Result<AdminUser, Error>) -> Void) {
            guard let url = URL(string: "\(baseURL)/get_admin_data.php?user_id=\(userID)") else {
                completion(.failure(APIError.invalidURL))
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                guard let data else {
                    completion(.failure(APIError.noData))
                    return
                }

                // Debug logging
                let raw = String(data: data, encoding: .utf8) ?? "<non-UTF8>"
                print("🔍 fetchAdminUser raw response:", raw)

                do {
                    let decoded = try JSONDecoder().decode(WrappedResponse<AdminUser>.self, from: data)
                    if let admin = decoded.data {
                        completion(.success(admin))
                    } else {
                        let msg = decoded.message ?? "Missing admin data"
                        completion(.failure(APIError.backend(msg)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }




    // MARK: - Fetch Progress
//    func fetchProgress(userID: Int, completion: @escaping (Result<ProgressData, Error>) -> Void) {
//        guard let url = URL(string: "\(baseURL)/get_progress.php?user_id=\(userID)") else {
//            print("❌ Invalid URL for fetchProgress")
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//
//        print("🔄 Fetching progress: \(url.absoluteString)")
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(APIError.noData))
//                return
//            }
//
//            do {
//                let decoded = try JSONDecoder().decode(ProgressResponse.self, from: data)
//                completion(.success(decoded.progress))
//            } catch {
//                print("❌ Decoding error in fetchProgress: \(error)")
//                completion(.failure(error))
//            }
//        }.resume()
//    }
    func fetchProgress(userID: Int, completion: @escaping (Result<ProgressData, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/get_progress.php?user_id=\(userID)") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ProgressResponse.self, from: data)
                completion(.success(decoded.progress))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }




    // MARK: - Fetch Current Course
//    func fetchCurrentCourse(week: Int, completion: @escaping (Result<Course, Error>) -> Void) {
//        guard let url = URL(string: "\(baseURL)/get_current_course.php?week=\(week)") else {
//            print("❌ Invalid URL for fetchCurrentCourse")
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//        print("🔄 Fetching course: \(url.absoluteString)")
//        fetchWrapped(url: url, completion: completion)
//    }
//    func fetchCurrentCourse(week: Int, completion: @escaping (Result<Course, Error>) -> Void) {
//        guard let url = URL(string: "\(baseURL)/get_current_course.php?week=\(week)") else {
//            completion(.failure(APIError.invalidURL))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(APIError.noData))
//                return
//            }
//
//            do {
//                let decoded = try JSONDecoder().decode(CourseResponse.self, from: data)
//
//                if let course = decoded.data {
//                    completion(.success(course))  // ✅ only return if data is not nil
//                } else {
//                    completion(.failure(APIError.custom(decoded.message ?? "No active course found.")))
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }
//
//        task.resume()
//    }
    func fetchCurrentCourse(week: Int, completion: @escaping (Result<Course, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/get_current_course.php?week=\(week)") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(CourseResponse.self, from: data)
                if let course = decoded.data {
                    completion(.success(course))
                } else {
                    let msg = decoded.message ?? "Course not available for this week"
                    completion(.failure(APIError.custom(msg)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
    enum APIError: Error, LocalizedError {
        case invalidURL
        case noData
        case decodingError
        case custom(String)
        case invalidResponse
        case backend(String)

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalid URL."
            case .noData: return "No data received."
            case .decodingError: return "Failed to decode response."
            case .invalidResponse: return "Invalid server response."
            case .custom(let message): return message
            case .backend(let msg): return msg
            }
        }
    }
    
    func fetchAdminActivities(completion: @escaping (Result<[AdminActivity], Error>) -> Void) {
        guard let url = URL(string: "http://localhost/skillnity/get_admin_activities.php") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: -1)))
                }
                return
            }

            // 🔹 DEBUG PRINT
            print("Raw JSON: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")

            do {
                let decoded = try JSONDecoder().decode(ActivityResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded.activities))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    

    struct ActivityResponse: Codable {
        let status: Bool
        let activities: [AdminActivity]
    }



    




    // MARK: - Generic Fetch for wrapped responses
    private func fetchWrapped<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }


    // MARK: - Login API
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login.php") else {
            print("❌ Invalid URL for login")
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = "username=\(username)&password=\(password)"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Login error: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data = data else {
                print("❌ No data from login")
                DispatchQueue.main.async { completion(.failure(APIError.noData)) }
                return
            }

            do {
                let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                print("✅ Login success for user: \(result.username)")
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                print("❌ Login decode error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
//    func updateProgress(userID: Int, quizzesPassed: Int, badgesEarned: Int, week: Int, completion: @escaping (Bool) -> Void) {
//        guard let url = URL(string: "\(baseURL)/update_progress.php") else {
//            print("Invalid URL")
//            completion(false)
//            return
//        }
//
//        let parameters: [String: Any] = [
//            "user_id": userID,
//            "quizzes_passed": quizzesPassed,
//            "badges_earned": badgesEarned,
//            "week": week
//        ]
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//        } catch {
//            print("Error encoding data: \(error)")
//            completion(false)
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Request error: \(error?.localizedDescription ?? "Unknown error")")
//                completion(false)
//                return
//            }
//
//            do {
//                let result = try JSONDecoder().decode([String: String].self, from: data)
//                if result["status"] == "success" {
//                    completion(true)
//                } else {
//                    print("Server error: \(result["message"] ?? "Unknown")")
//                    completion(false)
//                }
//            } catch {
//                print("Decoding error: \(error)")
//                completion(false)
//            }
//        }.resume()
//    }
    func updateProgress(userID: Int, quizCleared: Bool, badgeEarned: Bool, week: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/update_progress.php") else {
            print("Invalid URL")
            completion(false)
            return
        }

        let parameters: [String: Any] = [
            "user_id": userID,
            "quiz_cleared": quizCleared,
            "badge_earned": badgeEarned,
            "week": week
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error encoding data: \(error)")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Request error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }

            do {
                let result = try JSONDecoder().decode([String: String].self, from: data)
                if result["status"] == "success" {
                    completion(true)
                } else {
                    print("Server error: \(result["message"] ?? "Unknown")")
                    completion(false)
                }
            } catch {
                print("Decoding error: \(error)")
                completion(false)
            }
        }.resume()
    }
    func fetchNewCourses(completion: @escaping (Result<[NewCourse], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/get_admin_courses.php") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.invalidResponse))

                return
            }

            do {
                let courses = try JSONDecoder().decode([NewCourse].self, from: data)
                completion(.success(courses))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }





}
struct UpdateResponse: Codable {
    let success: Bool
}

// MARK: - Generic Wrapper
struct WrappedResponse<T: Codable>: Codable {
    let data: T?
    let message: String?
}

// MARK: - Custom API Errors
//enum APIError: Error {
//    case invalidURL
//    case noData
//    case invalidResponse
//}

