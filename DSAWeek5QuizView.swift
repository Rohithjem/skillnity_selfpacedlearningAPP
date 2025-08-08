//
//  DSAWeek5QuizView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 22/07/25.
//

import Foundation

import SwiftUI



struct DSAWeek5QuizView: View {
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var answered = false
    @State private var showCorrectAnimation = false
    @State private var showWrongAnimation = false
    @State private var navigateToResult = false

    let userID: Int
    let questions: [Question] = [
        // Trees
        Question(question: "What is a binary tree?", options: [ "A tree with only left nodes","A tree where each node has at most two children", "A tree with at least two children", "A tree where nodes are sorted"], correctAnswerIndex: 1),
        Question(question: "Which traversal visits nodes in the order: left, root, right?", options: [ "Preorder", "Postorder","Inorder", "Level Order"], correctAnswerIndex: 2),
        Question(question: "Which data structure is used in Level Order traversal of a tree?", options: ["Queue", "Stack", "Linked List", "Array"], correctAnswerIndex: 0),
        Question(question: "In a Binary Search Tree (BST), where are smaller elements placed?", options: [ "Right subtree", "Root", "Leaves","Left subtree"], correctAnswerIndex: 3),
        Question(question: "What is the maximum number of nodes in a binary tree of height h?", options: [ "2h", "h^2","2^h - 1", "h!"], correctAnswerIndex: 2),
        Question(question: "What is a leaf node?", options: [ "A node with one child","A node with no children", "The root node", "A node with two children"], correctAnswerIndex: 1),
        Question(question: "Which traversal is best for evaluating an expression tree?", options: ["Postorder", "Inorder", "Preorder", "Level Order"], correctAnswerIndex: 0),
        Question(question: "What makes a tree a complete binary tree?", options: [ "Each node has two children", "All nodes are leaves", "All nodes are root","All levels filled except possibly the last, filled from left to right"], correctAnswerIndex: 3),

        // Graphs
        Question(question: "What is a graph?", options: [ "A tree with loops","A set of vertices connected by edges", "A circular linked list", "A sequence of numbers"], correctAnswerIndex: 1),
        Question(question: "Which of the following is used to represent a graph?", options: ["Adjacency matrix", "Stack", "Queue", "Binary Tree"], correctAnswerIndex: 0),
        Question(question: "What is the time complexity of BFS on a graph with V vertices and E edges?", options: [ "O(V²)", "O(VE)","O(V + E)", "O(log V)"], correctAnswerIndex: 0),
        Question(question: "Which graph traversal uses a queue?", options: ["Breadth-First Search", "Depth-First Search", "Inorder", "Preorder"], correctAnswerIndex: 2),
        Question(question: "Which algorithm is used to find the shortest path in a weighted graph without negative weights?", options: ["Dijkstra's Algorithm", "DFS", "BFS", "Bellman-Ford"], correctAnswerIndex: 0),
        Question(question: "What is a cycle in a graph?", options: ["A path that visits all nodes", "A path that starts and ends at the same vertex","A loop in recursion", "A repeated edge"], correctAnswerIndex: 1),
        Question(question: "Which of the following detects cycles in a directed graph?", options: ["DFS with visited & recursion stack", "BFS only", "Dijkstra", "Kruskal"], correctAnswerIndex: 0)
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
        .navigationTitle("Week 5 Quiz")
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
                    onQuizCompleted(currentWeek: 5, newScore: score)

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
