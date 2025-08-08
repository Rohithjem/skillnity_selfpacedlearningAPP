//
//  Models.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 30/05/25.
//

import Foundation
struct User: Codable {
    let id: Int
    let username: String
    let college_name: String
    let email: String
    let profile_pic: String?
}
struct AdminUser: Codable {
    let id: Int
    let username: String
    let profile_pic: String?
}

struct Progress: Codable {
    let user_id: Int
    let week: Int
    let badges_earned: Int
    let quizzes_passed: Int
    let updated_at: String
}
//struct Progress: Decodable {
//    let user_id: Int
//    let quizzesPassed: Int
//    let badgesEarned: Int
//    let week: Int
//    let updated_at: String
//
//    enum CodingKeys: String, CodingKey {
//        case quizzesPassed = "quizzes_passed"
//        case badgesEarned = "badges_earned"
//        case week
//    }
//}
struct ProgressResponse: Codable {
    let status: String
    let progress: ProgressData
}

//struct ProgressData: Codable {
//    let week: Int
//    let badges_earned: Int
//    let quizzes_passed: Int
//
//    var overallProgress: Double {
//        // Adjust max quizzes and badges as needed
//        let maxQuizzes = 5.0
//        let maxBadges = 5.0
//        let quizProgress = Double(quizzes_passed) / maxQuizzes
//        let badgeProgress = Double(badges_earned) / maxBadges
//        return (quizProgress + badgeProgress) / 2.0
//    }
//}

//struct ProgressData: Codable {
//    let id: String
//    let user_id: String
//    let badges_earned: String
//    let quizzes_passed: String
//    let week: Int
//}
//struct ProgressData: Codable {
//    let id: String
//    let user_id: String
//    let badges_earned: String
//    let quizzes_passed: String
//    let week: Int  // ✅ Already Int!
//}
//struct ProgressData: Codable {
//    let id: String
//    let user_id: String
//    let badges_earned: String
//    let quizzes_passed: String
//    let week: Int
//}

//struct ProgressData: Codable {
//    let id: String
//    let user_id: String
//    let badges_earned: String
//    let quizzes_passed: String
//    let week: Int
//
//    var overallProgress: Double {
//        guard let badges = Int(badges_earned),
//              let quizzes = Int(quizzes_passed),
//              week > 0 else {
//            return 0.0
//        }
//
//        let badgeScore = Double(badges) / Double(week)
//        let quizScore = Double(quizzes) / Double(week)
//        return min(1.0, (badgeScore + quizScore) / 2.0)
//    }
//}
//struct ProgressData: Codable {
//    let week: Int
//    let quizzes_passed: Int
//    let badges_earned: Int
//}
//struct ProgressData: Codable {
//    let week: Int
//    let quizzes_passed: Int
//    let badges_earned: Int
//}
//
struct ProgressData: Codable {
    let week: Int
    let quizzes_passed: Int
    let badges_earned: Int
    let week1_score: Int?
    let week2_score: Int?
    let week3_score: Int?
    let week4_score: Int?
    let week5_score: Int?

    var bestScores: [Int: Int] {
        return [
            1: week1_score ?? 0,
            2: week2_score ?? 0,
            3: week3_score ?? 0,
            4: week4_score ?? 0,
            5: week5_score ?? 0
        ]
    }
}



struct Course: Codable {
    let title: String
    let description: String
    let week: Int
}


//struct CourseResponse: Codable {
//    let status: String
//    let message: String
//    let id: Int? 
//    let data: Course?// Only comes in create
//}
struct CourseResponse: Codable {
    let data: Course?
    let message: String? // optional error message
    
}

//struct Course: Identifiable {
//    let id = UUID()
//    let title: String
//    let description: String
//    let week: Int
//}


//struct ResumeProject: Identifiable, Codable {
//    let id: Int
//    let title: String
//    let type: String
//    let short_description: String
//    let full_description: String
//    let icon_name: String
//    let technologies: String?
//    let tips: String?
//}
//struct ResumeProject: Identifiable, Codable {
//    var id: Int
//    var title: String
//    var type: String
//    var short_description: String
//    var full_description: String
//    var icon_name: String?
//    let technologies: String?
//}

struct ResumeProject: Identifiable, Codable {
    let id: Int
    let title: String
    let type: String
    let short_description: String
    let full_description: String
    let icon_name: String?
}

//struct AdminActivity: Identifiable, Codable {
//    let id: Int
//    let title: String
//    let description: String
//    let timestamp: String
//}
//struct AdminActivity: Codable {
//    let id: String
//    let title: String
//    let description: String
//    let timestamp: String
//}
struct AdminActivity: Codable, Identifiable {
    let id: String       // Ensure this is String since your JSON shows string IDs
    let title: String
    let description: String
    let timestamp: String
}

//struct NewCourse: Identifiable, Codable {
//    let id: Int
//    let title: String
//    let description: String
//    let image_url: String
//    let is_active: Int
//    let created_at: String
//
//    // map backend keys that come as strings to proper types
//    private enum CodingKeys: String, CodingKey {
//        case id, title, description, image_url, is_active, created_at
//    }
//
//    // In case the backend sends numbers as strings, provide custom init
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        // id may come as string
//        if let idInt = try? container.decode(Int.self, forKey: .id) {
//            id = idInt
//        } else {
//            let idStr = try container.decode(String.self, forKey: .id)
//            id = Int(idStr) ?? 0
//        }
//
//        title = try container.decode(String.self, forKey: .title)
//        description = try container.decode(String.self, forKey: .description)
//        image_url = try container.decode(String.self, forKey: .image_url)
//
//        if let activeInt = try? container.decode(Int.self, forKey: .is_active) {
//            is_active = activeInt
//        } else {
//            let activeStr = try container.decode(String.self, forKey: .is_active)
//            is_active = Int(activeStr) ?? 0
//        }
//
//        created_at = try container.decode(String.self, forKey: .created_at)
//    }
//}
