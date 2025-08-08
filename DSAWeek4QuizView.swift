//
//  DSAWeek4QuizView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 22/07/25.
//

import Foundation
import SwiftUI



struct DSAWeek4QuizView: View {
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var answered = false
    @State private var showCorrectAnimation = false
    @State private var showWrongAnimation = false
    @State private var navigateToResult = false

    let userID: Int
    let questions: [Question] = [
        // Recursion
        Question(question: "What is recursion?", options: [ "A loop", "A class inheritance","A function calling itself", "A data structure"], correctAnswerIndex: 1),
        Question(question: "Which of the following problems is best solved using recursion?", options: ["Sorting an array with bubble sort", "Printing a list","Calculating factorial",  "Finding average"], correctAnswerIndex: 2),
        Question(question: "What is the base case in recursion?", options: ["The case where recursion stops", "The case where loop starts", "The maximum input value", "A constant"], correctAnswerIndex: 0),
        Question(question: "Which data structure is used for function calls in recursion?", options: ["Queue", "Array", "Heap","Stack"], correctAnswerIndex: 3),
        Question(question: "What will happen if the base case is missing in a recursive function?", options: [ "Syntax error","Stack overflow", "It will run once", "Nothing happens"], correctAnswerIndex: 1),

        // Sorting
        Question(question: "Which sorting algorithm has the best average case time complexity?", options: [ "Bubble Sort", "Insertion Sort","Merge Sort", "Selection Sort"], correctAnswerIndex: 2),
        Question(question: "What is the time complexity of Quick Sort in the average case?", options: ["O(n log n)", "O(n)", "O(n²)", "O(log n)"], correctAnswerIndex: 0),
        Question(question: "Which sorting algorithm repeatedly swaps adjacent elements if they are in the wrong order?", options: [ "Selection Sort","Bubble Sort", "Quick Sort", "Merge Sort"], correctAnswerIndex: 1),
        Question(question: "Which sorting algorithm uses divide and conquer?", options: ["Merge Sort", "Bubble Sort", "Insertion Sort", "Counting Sort"], correctAnswerIndex: 0),
        Question(question: "Which algorithm is not a comparison-based sorting algorithm?", options: [ "Merge Sort", "Quick Sort", "Heap Sort","Counting Sort"], correctAnswerIndex: 3)
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
        .navigationTitle("Week 4 Quiz")
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
                    onQuizCompleted(currentWeek: 4, newScore: score)

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
