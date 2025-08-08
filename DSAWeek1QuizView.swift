import SwiftUI
import Foundation

struct Question {
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
}

struct DSAWeek1QuizView: View {
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var answered = false
    @State private var showCorrectAnimation = false
    @State private var showWrongAnimation = false
    @State private var navigateToResult = false

    let userID: Int
    let questions: [Question] = [
        Question(
            question: "Which data structure follows the Last In First Out (LIFO) principle?",
            options: ["Tree", "Array", "Stack", "Queue"],
            correctAnswerIndex: 2
        ),
        Question(
            question: "Which of the following is used for decision-making in Swift?",
            options: ["if", "switch", "for", "repeat"],
            correctAnswerIndex: 0
        ),
        Question(
            question: "What kind of error occurs during program execution?",
            options: ["Runtime error", "Syntax error", "Compile-time error", "Logic error"],
            correctAnswerIndex: 0
        ),
        Question(
            question: "Which keyword in Swift is used to iterate a fixed number of times?",
            options: ["for", "while", "repeat", "switch"],
            correctAnswerIndex: 0
        ),
        Question(
            question: "Which pattern prints stars in right-angled format?",
            options: ["Zigzag", "Inverted", "Pyramid", "Right-angled"],
            correctAnswerIndex: 3
        ),
        Question(
            question: "What is type casting in Swift?",
            options: ["Changing a value from one data type to another", "Accessing arrays", "Using logical operators", "Printing a value"],
            correctAnswerIndex: 0
        ),
        Question(
            question: "Which of these is NOT an arithmetic operator in Swift?",
            options: ["*", "==", "+", "-"],
            correctAnswerIndex: 1
        ),
        Question(
            question: "Which statement correctly compares two values?",
            options: ["5 + 3", "5 == 3", "5 * 3", "5 - 3"],
            correctAnswerIndex: 1
        ),
        Question(
            question: "Which of the following is a logical operator?",
            options: ["||", "**", "//", "--"],
            correctAnswerIndex: 0
        ),
        Question(
            question: "Which loop is guaranteed to execute at least once?",
            options: ["repeat-while", "while", "for", "foreach"],
            correctAnswerIndex: 0
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
        .navigationTitle("Week 1 Quiz")
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
                    onQuizCompleted(currentWeek: 1,newScore: score)
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
