//
//  DSAWeek1View.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 09/07/25.
//

import Foundation
import SwiftUI

struct DSAWeek1View: View {
    let userID: Int
    @State private var navigateToQuiz = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Week Title
                Text("📘 Week 1: DSA Basics")
                    .font(.title.bold())
                    .padding(.top)

                // Overview
                Text("This week covers:")
                    .font(.headline)
                    .foregroundColor(.themePurple)

                VStack(alignment: .leading, spacing: 10) {
                    Text("✅ What is DSA?")
                    Text("✅ Loops in Swift")
                    Text("✅ Conditional Statements")
                    Text("✅ Operators")
                    Text("✅ Type Casting")
                    Text("✅ Types of Errors")
                    Text("✅ Pattern Building Problems")
                }
                .font(.subheadline)
                .foregroundColor(.black)

                Divider().padding(.vertical)

                // Introduction
                Text("📌 What is DSA?")
                    .font(.headline)
                Text("Data Structures and Algorithms (DSA) are fundamental to writing efficient code and building optimized software. Data Structures are used to store and organize data, while algorithms manipulate that data to solve problems efficiently.")
                Text("Examples: Arrays, Linked Lists, Stacks, Queues, Trees, Graphs")

                // Loops Section
                Text("🔁 Loops in Swift")
                    .font(.headline)
                Text("Loops allow you to repeat a block of code multiple times. Swift supports three main types of loops:")
                Group {
                    Text("1️⃣ for-in loop")
                    Text("Example:")
                    CodeBlock("""
                    for number in 1...5 {
                        print(number)
                    }
                    """)
                    Text("2️⃣ while loop")
                    Text("Example:")
                    CodeBlock("""
                    var i = 0
                    while i < 5 {
                        print(i)
                        i += 1
                    }
                    """)
                    Text("3️⃣ repeat-while loop")
                    Text("Example:")
                    CodeBlock("""
                    var j = 0
                    repeat {
                        print(j)
                        j += 1
                    } while j < 5
                    """)
                }

                // Conditionals Section
                Text("🧠 Conditional Statements")
                    .font(.headline)
                Text("Conditional statements control the flow of execution based on conditions.")
                Text("1️⃣ if-else Statement")
                CodeBlock("""
                let age = 18
                if age >= 18 {
                    print("Adult")
                } else {
                    print("Minor")
                }
                """)
                Text("2️⃣ switch Statement")
                CodeBlock("""
                let grade = "A"
                switch grade {
                case "A": print("Excellent")
                case "B": print("Good")
                default: print("Needs Improvement")
                }
                """)

                // Operators Section
                Text("➕ Operators in Swift")
                    .font(.headline)
                Text("Operators are special symbols or phrases used to check, combine, or change values.")
                Group {
                    Text("✅ Arithmetic Operators: +, -, *, /, %")
                    Text("✅ Comparison Operators: ==, !=, >, <, >=, <=")
                    Text("✅ Logical Operators: &&, ||, !")
                }
                CodeBlock("""
                let a = 5, b = 3
                print(a + b)  // 8
                print(a > b)  // true
                print(a > 0 && b > 0) // true
                """)

                // Type Casting Section
                // Type Casting Section
                Text("🔄 Type Casting")
                    .font(.headline)
                Text("Type casting allows you to treat an instance as a different class within its hierarchy.")
                CodeBlock("""
                let value: Any = "Skillnity"
                if let stringValue = value as? String {
                    print("Casted value: \\(stringValue)")
                }
                """)


                // Errors Section
                Text("🚫 Types of Errors")
                    .font(.headline)
                Group {
                    Text("1️⃣ Compile-time Errors: Errors caught by the compiler.")
                    Text("2️⃣ Runtime Errors: Errors that occur during execution.")
                    Text("3️⃣ Logical Errors: Program runs but gives wrong output due to wrong logic.")
                }
                CodeBlock("""
                // Logical Error Example
                let x = 10
                let y = 2
                print(x - y) // Output is 8 but if intention was division, it's incorrect
                """)

                // Pattern Problems
                Text("🎯 Pattern Problems")
                    .font(.headline)
                Text("Pattern problems are helpful in improving your understanding of loops and logic building.")
                Text("Example: Print the following pattern:")
                CodeBlock("""
                *
                **
                ***
                ****
                *****
                """)
                CodeBlock("""
                for i in 1...5 {
                    var line = ""
                    for _ in 1...i {
                        line += "*"
                    }
                    print(line)
                }
                """)

                Divider().padding(.vertical)

                LottieView(animationName: "learning_animation", loopMode: .loop)
                    .frame(height: 200)

                Button(action: {
                    navigateToQuiz = true
                }) {
                    Text("Start Quiz")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.themePurple)
                        .cornerRadius(20)
                }
            }
            .padding()
        }
        .navigationTitle("Week 1 - Basics")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white.ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToQuiz) {
            DSAWeek1QuizView(userID: userID)
        }
    }
}

// MARK: - Helper View for Code Blocks
struct CodeBlock: View {
    var code: String
    init(_ code: String) {
        self.code = code
    }

    var body: some View {
        ScrollView(.horizontal) {
            Text(code)
                .font(.system(.body, design: .monospaced))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 10)
        }
    }
}
