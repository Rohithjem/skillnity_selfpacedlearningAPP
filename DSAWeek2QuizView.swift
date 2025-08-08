//
//  DSAWeek2QuizView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 22/07/25.
//

import SwiftUI
import Foundation


struct DSAWeek2QuizView: View {
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var answered = false
    @State private var showCorrectAnimation = false
    @State private var showWrongAnimation = false
    @State private var navigateToResult = false

    let userID: Int
    let questions: [Question] = [
        Question(
            question: "What is the time complexity of accessing an element in an array?",
            options: ["O(1)", "O(n)", "O(log n)", "O(n log n)"],
            correctAnswerIndex: 0
        ),
        Question(
            question: "Which keyword is used to iterate over elements in an array in Swift?",
            options: ["if", "while", "for", "switch"],
            correctAnswerIndex: 2
        ),
        Question(
            question: "Which of the following operations has a time complexity of O(n) in an array?",
            options: ["Access by index", "Update element", "Insert at beginning", "Random access"],
            correctAnswerIndex: 2
        ),
        Question(
            question: "What is the output of: `print(\"hello\".reversed())`?",
            options: ["olleh", "An array of characters", "Error", "hello"],
            correctAnswerIndex: 1
        ),
        Question(
            question: "Which method is used to find the maximum in an array in Swift?",
            options: ["arr.top()", "arr.findMax()", "arr.max()", "arr.maximum()"],
            correctAnswerIndex: 2
        ),
        Question(
            question: "What is the purpose of Big-O notation?",
            options: ["To measure how code looks", "To calculate memory space", "To evaluate algorithm efficiency", "To write code faster"],
            correctAnswerIndex: 2
        ),
        Question(
            question: "Which of the following is true about Swift Arrays?",
            options: ["They are linked lists", "They are fixed in size always", "They store heterogeneous types", "They are value types"],
            correctAnswerIndex: 3
        ),
        Question(
            question: "What is the time complexity of linear search in an array?",
            options: ["O(n)", "O(1)", "O(log n)", "O(n log n)"],
            correctAnswerIndex: 0
        ),
        Question(
            question: "Which function checks if two strings are anagrams in Swift?",
            options: ["sort(str1) == sort(str2)", "reverse(str1) == str2", "join(str1) == str2", "append(str1, str2)"],
            correctAnswerIndex: 0
        ),
        Question(
            question: "Which collection in Swift is best suited for dynamic data resizing?",
            options: ["Tuple", "Array", "Set", "Dictionary"],
            correctAnswerIndex: 1
        )
    ]



    var body: some View {
        VStack(spacing: 20) {
            Text("Question \(currentIndex + 1) of \(questions.count)")
                .font(.headline)

            Text(questions[currentIndex].question)
                .font(.title3)
                .multilineTextAlignment(.center)

            ForEach(0..<questions[currentIndex].options.count, id: \.self) { index in
                Button(action: {
                    if !answered {
                        handleAnswer(index)
                    }
                }) {
                    Text(questions[currentIndex].options[index])
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .shadow(radius: 2)
                }
                .disabled(answered) // disable after answer
            }

            // ✅ Correct animation
            if showCorrectAnimation {
                LottieView(animationName: "success_tick", loopMode: .playOnce)
                    .frame(height: 120)
                    .transition(.scale)
            }

            // ❌ Wrong animation
            if showWrongAnimation {
                LottieView(animationName: "wrong", loopMode: .playOnce)
                    .frame(height: 120)
                    .transition(.scale)
            }

            Spacer()

            NavigationLink(
                destination: QuizResultView(score: score, total: questions.count),
                isActive: $navigateToResult,
                label: { EmptyView() }
            )
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true) // ✅ Hides back button
        .navigationTitle("Week 2 Quiz")
    }

    func handleAnswer(_ selectedIndex: Int) {
        answered = true

        let isCorrect = selectedIndex == questions[currentIndex].correctAnswerIndex

        if isCorrect {
            score += 10
            withAnimation {
                showCorrectAnimation = true
            }
        } else {
            withAnimation {
                showWrongAnimation = true
            }
        }

        // Go to next after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation {
                showCorrectAnimation = false
                showWrongAnimation = false
            }
            answered = false

            if currentIndex + 1 < questions.count {
                currentIndex += 1
            } else {
                updateScoreInLeaderboard(score: score)

                if score > 50 {
                    onQuizCompleted(currentWeek: 2,newScore: score)
                }

                navigateToResult = true
            }
        }
    }

    func updateScoreInLeaderboard(score: Int) {
        guard let url = URL(string: "http://localhost/skillnity/update_leaderboard.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let payload = ["user_id": userID, "points": score]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request).resume()
    }

//    func onQuizCompleted(currentWeek: Int) {
//        let nextWeek = currentWeek >= 5 ? 5 : currentWeek + 1
//
//
//        APIService.shared.updateProgress(
//            userID: userID,
//            quizzesPassed: progress?.quizzes_passed ?? 0 + 1,
//            badgesEarned: score >= 20 ? 2 : 0,
//            week: nextWeek
//        ) { success in
//            if success {
//                DispatchQueue.main.async {
//                    AppState.shared.profileUpdated = true
//                }
//            }
//        }
//    }
//    func onQuizCompleted(currentWeek: Int) {
//        let nextWeek = min(currentWeek + 1, 5)
//
//        APIService.shared.fetchProgress(userID: userID) { result in
//            switch result {
//            case .success(let progress):
//                let updatedQuizzesPassed = (Int(progress.quizzes_passed) ) + 1
//                let updatedBadges = (Int(progress.badges_earned) ) + (score >= 20 ? 1 : 0)
//
//                APIService.shared.updateProgress(
//                    userID: userID,
//                    quizzesPassed: updatedQuizzesPassed,
//                    badgesEarned: updatedBadges,
//                    week: nextWeek
//                ) { success in
//                    if success {
//                        DispatchQueue.main.async {
//                            AppState.shared.profileUpdated = true
//                        }
//                    }
//                }
//
//            case .failure(let error):
//                print("Failed to fetch progress: \(error.localizedDescription)")
//            }
//        }
//
//    }
//    func onQuizCompleted(currentWeek: Int, newScore: Int) {
//        let nextWeek = min(currentWeek + 1, 5)
//
//        let badgeThresholds: [Int: Int] = [
//            1: 20, 2: 40, 3: 60, 4: 80, 5: 100
//        ]
//        let requiredScore = badgeThresholds[currentWeek] ?? 20
//
//        APIService.shared.fetchProgress(userID: userID) { result in
//            switch result {
//            case .success(let progress):
//                let previousBestScore = progress.bestScores[currentWeek] ?? 0
//
//                // Only update if the new score is better
//                if newScore > previousBestScore {
//                    var updatedBadges = Int(progress.badges_earned)
//                    let hadBadge = previousBestScore >= requiredScore
//                    let nowEarnsBadge = newScore >= requiredScore
//
//                    // Only increase badge count if it's newly earned
//                    if !hadBadge && nowEarnsBadge {
//                        updatedBadges += 1
//                    }
//
//                    APIService.shared.updateProgress(
//                        userID: userID,
//                        quizzesPassed: Int(progress.quizzes_passed),
//                        badgesEarned: updatedBadges,
//                        week: nextWeek
//                    ) { success in
//                        if success {
//                            DispatchQueue.main.async {
//                                AppState.shared.profileUpdated = true
//                            }
//                        }
//                    }
//
//                }
//
//            case .failure(let error):
//                print("Failed to fetch progress: \(error.localizedDescription)")
//            }
//        }
//    }
    func onQuizCompleted(currentWeek: Int, newScore: Int) {
        let nextWeek = min(currentWeek + 1, 5)

        let badgeThresholds: [Int: Int] = [
            1: 20, 2: 40, 3: 60, 4: 80, 5: 100
        ]
        let requiredScore = badgeThresholds[currentWeek] ?? 20

        APIService.shared.fetchProgress(userID: userID) { result in
            switch result {
            case .success(let progress):
                let previousBestScore = progress.bestScores[currentWeek] ?? 0
                let hadBadge = previousBestScore >= requiredScore
                let nowEarnsBadge = newScore >= requiredScore

                var updatedBadges = Int(progress.badges_earned)
                var updatedQuizzes = Int(progress.quizzes_passed)

                // Increment badge if newly earned
                if !hadBadge && nowEarnsBadge {
                    updatedBadges += 1
                }

                // Increment quiz count only if this is first attempt
                if previousBestScore == 0 {
                    updatedQuizzes += 1
                }

                APIService.shared.updateProgress(
                    userID: userID,
                    quizCleared: updatedQuizzes != 0,
                    badgeEarned: updatedBadges != 0,
                    week: nextWeek
                ) { success in
                    if success {
                        DispatchQueue.main.async {
                            AppState.shared.profileUpdated = true
                        }
                    }
                }


            case .failure(let error):
                print("Failed to fetch progress: \(error.localizedDescription)")
            }
        }
    }






}
