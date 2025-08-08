//
//  ProgressData.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 24/07/25.
//
//
import Foundation
//extension ProgressData {
//    
//    var overallProgress: Double {
//        let badgeScore = Double(badges_earned)
//        let quizScore = Double(quizzes_passed)
//        let maxScore = Double(week * 2) // assuming 1 badge + 1 quiz per week
//        return min(1.0, (badgeScore + quizScore) / maxScore)
//    }
//}
//extension ProgressData {
//    var overallProgress: Double {
//        let totalWeeks = 5
//        let badgeScore = Double(badges_earned)
//        let quizScore = Double(quizzes_passed)
//        let maxScore = Double(totalWeeks * 2) // total possible points
//        return min(1.0, (badgeScore + quizScore) / maxScore)
//    }
//}
extension ProgressData {
    var overallProgress: Double {
        let totalTasks = 5 * 2 // 5 weeks * (1 badge + 1 quiz)
        let completedTasks = badges_earned + quizzes_passed
        return Double(completedTasks) / Double(totalTasks)
    }
}


//extension ProgressData {
//
//    var overallProgress: Double {
//        guard let progress = progress,
//              let badges = Int(progress.badges_earned),
//              let quizzes = Int(progress.quizzes_passed),
//              progress.week > 0 else {
//            return 0.0
//        }
//
//        let badgeScore = Double(badges) / Double(progress.week)
//        let quizScore = Double(quizzes) / Double(progress.week)
//        let average = (badgeScore + quizScore) / 2.0
//
//        return min(1.0, average)
//    }
//
//
//
//}
//import Foundation
//
//extension ProgressData {
//    var overallProgress: Double {
//        guard let badges = Double(badges_earned),
//              let quizzes = Double(quizzes_passed),
//              week > 0 else {
//            return 0.0
//        }
//
//        let badgeScore = badges / Double(week)
//        let quizScore = quizzes / Double(week)
//        let average = (badgeScore + quizScore) / 2.0
//
//        return min(1.0, average)
//    }
//}

//    var overallProgress: Double {
//        guard let progress = progress,
//              let badges = Int(progress.badges_earned),
//              let quizzes = Int(progress.quizzes_passed),
//              progress.week > 0 else { return 0.0 }
//
//        let badgeScore = Double(badges) / Double(progress.week)
//        let quizScore = Double(quizzes) / Double(progress.week)
//        let average = (badgeScore + quizScore) / 2.0
//        return min(1.0, average)
//    }
//    var overallProgress: Double {
//        guard let badges = Int(badges_earned),
//              let quizzes = Int(quizzes_passed),
//              week > 0 else {
//            return 0.0
//        }
//
//        let badgeScore = Double(badges) / Double(week)
//        let quizScore = Double(quizzes) / Double(week)
//        let average = (badgeScore + quizScore) / 2.0
//        return min(1.0, average) // ensures it never goes above 1.0 (100%)
//    }
