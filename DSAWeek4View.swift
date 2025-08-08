//
//  DSAWeek4View.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 16/07/25.
//

import Foundation
import SwiftUI

struct DSAWeek4View: View {
    let userID: Int
    @State private var navigateToQuiz = false
    let sortingData: [SortingInfo] = [
        SortingInfo(algorithm: "Bubble Sort", best: "O(n)", worst: "O(n²)", stable: "✅", inPlace: "✅"),
        SortingInfo(algorithm: "Selection Sort", best: "O(n²)", worst: "O(n²)", stable: "❌", inPlace: "✅"),
        SortingInfo(algorithm: "Insertion Sort", best: "O(n)", worst: "O(n²)", stable: "✅", inPlace: "✅"),
        SortingInfo(algorithm: "Merge Sort", best: "O(n log n)", worst: "O(n log n)", stable: "✅", inPlace: "❌"),
        SortingInfo(algorithm: "Quick Sort", best: "O(n log n)", worst: "O(n²)", stable: "❌", inPlace: "✅")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("📘 Week 4: Recursion and Sorting")
                    .font(.title.bold())
                    .padding(.top)

                Text("This week covers:")
                    .font(.headline)
                    .foregroundColor(.themePurple)

                VStack(alignment: .leading, spacing: 10) {
                    Text("✔️ What is Recursion?")
                    Text("✔️ Base Case and Recursive Case")
                    Text("✔️ Recursive Tree Visualization")
                    Text("✔️ Head vs Tail Recursion")
                    Text("✔️ Backtracking Basics")
                    Text("✔️ Common Recursive Patterns")
                    Text("✔️ Bubble, Selection & Insertion Sort")
                    Text("✔️ Merge Sort & Quick Sort")
                    Text("✔️ Sorting Stability & In-Place Sorting")
                    Text("✔️ Time and Space Complexities")
                }
                .font(.subheadline)
                .foregroundColor(.black)

                Divider().padding(.vertical)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Recursion Section
                        RecursionSection()

                        // Sorting Section
                        SortingSection(sortingData: sortingData)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                }

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
        .navigationTitle("Week 4 - Recursion and Sorting")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white.ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToQuiz) {
            DSAWeek4QuizView(userID: userID)
        }
    }
}

struct SortingInfo {
    let algorithm: String
    let best: String
    let worst: String
    let stable: String
    let inPlace: String
}

// Modular Recursion View Section
struct RecursionSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("🔁 Recursion")
                .font(.title2.bold())

            Text("Recursion is a technique where a function calls itself to solve smaller subproblems.")

            Text("Every recursive function has two main parts:")
            Text("- **Base Case**: The stopping condition for recursion.")
            Text("- **Recursive Case**: Calls itself with a smaller problem.")

            Text("Example - Factorial:")
            Text("""
            func factorial(_ n: Int) -> Int {
                if n == 0 { return 1 }
                return n * factorial(n - 1)
            }
            """)
            .font(.system(.body, design: .monospaced))

            Text("Types of Recursion:")
            Text("- **Head Recursion**: Recursive call is first.")
            Text("- **Tail Recursion**: Recursive call is last (can be optimized).")

            Text("🔙 Backtracking")
                .font(.headline)
            Text("Backtracking explores all possibilities and undoes decisions to find solutions.")
            Text("Use Cases: Maze solving, N-Queens, Subset sum problems")

            Text("Example - N-Queens Skeleton:")
            Text("""
            func solveNQueens(_ n: Int) -> [[String]] {
                var board = Array(repeating: String(repeating: ".", count: n), count: n)
                var result = [[String]]()
                func backtrack(_ row: Int) {
                    if row == n {
                        result.append(board)
                        return
                    }
                    for col in 0..<n {
                        if isValid(row, col) {
                            placeQueen(row, col)
                            backtrack(row + 1)
                            removeQueen(row, col)
                        }
                    }
                }
                backtrack(0)
                return result
            }
            """)
            .font(.system(.body, design: .monospaced))
        }
    }
}

// Modular Sorting View Section
struct SortingSection: View {
    let sortingData: [SortingInfo]
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("🔃 Sorting Algorithms")
                .font(.title2.bold())

            Text("Sorting organizes data in a specific order. Common uses include searching, analytics, and data organization.")

            Group {
                Text("🔔 Bubble Sort")
                    .font(.headline)
                Text("Repeatedly compares adjacent elements and swaps them if out of order.")
                Text("""
                func bubbleSort(_ arr: inout [Int]) {
                    for i in 0..<arr.count {
                        for j in 0..<arr.count - i - 1 {
                            if arr[j] > arr[j + 1] {
                                arr.swapAt(j, j + 1)
                            }
                        }
                    }
                }
                """)
                .font(.system(.body, design: .monospaced))
            }

            Group {
                Text("🔖 Selection Sort")
                    .font(.headline)
                Text("Finds the minimum and swaps it to the front.")
                Text("""
                func selectionSort(_ arr: inout [Int]) {
                    for i in 0..<arr.count {
                        var minIdx = i
                        for j in i+1..<arr.count {
                            if arr[j] < arr[minIdx] {
                                minIdx = j
                            }
                        }
                        arr.swapAt(i, minIdx)
                    }
                }
                """)
                .font(.system(.body, design: .monospaced))
            }

            Group {
                Text("🔘 Insertion Sort")
                    .font(.headline)
                Text("Builds the sorted array one element at a time.")
                Text("""
                func insertionSort(_ arr: inout [Int]) {
                    for i in 1..<arr.count {
                        let key = arr[i]
                        var j = i - 1
                        while j >= 0 && arr[j] > key {
                            arr[j + 1] = arr[j]
                            j -= 1
                        }
                        arr[j + 1] = key
                    }
                }
                """)
                .font(.system(.body, design: .monospaced))
            }

            Group {
                Text("🔵 Merge Sort")
                    .font(.headline)
                Text("Divide and conquer algorithm that splits and merges arrays.")
                Text("""
                func mergeSort(_ arr: [Int]) -> [Int] {
                    guard arr.count > 1 else { return arr }
                    let mid = arr.count / 2
                    let left = mergeSort(Array(arr[0..<mid]))
                    let right = mergeSort(Array(arr[mid...]))
                    return merge(left, right)
                }

                func merge(_ left: [Int], _ right: [Int]) -> [Int] {
                    var result: [Int] = []
                    var i = 0, j = 0

                    while i < left.count && j < right.count {
                        if left[i] < right[j] {
                            result.append(left[i])
                            i += 1
                        } else {
                            result.append(right[j])
                            j += 1
                        }
                    }
                    result += left[i...]
                    result += right[j...]
                    return result
                }
                """)
                .font(.system(.body, design: .monospaced))
            }

            Group {
                Text("🔶 Quick Sort")
                    .font(.headline)
                Text("Picks a pivot and partitions the array.")
                Text("""
                func quickSort(_ arr: inout [Int], _ low: Int, _ high: Int) {
                    if low < high {
                        let pi = partition(&arr, low, high)
                        quickSort(&arr, low, pi - 1)
                        quickSort(&arr, pi + 1, high)
                    }
                }

                func partition(_ arr: inout [Int], _ low: Int, _ high: Int) -> Int {
                    let pivot = arr[high]
                    var i = low
                    for j in low..<high {
                        if arr[j] < pivot {
                            arr.swapAt(i, j)
                            i += 1
                        }
                    }
                    arr.swapAt(i, high)
                    return i
                }
                """)
                .font(.system(.body, design: .monospaced))
            }

            Text("Sorting Comparison Table")
                .font(.headline)

            VStack(spacing: 8) {
                HStack {
                    Text("Algorithm").bold().frame(maxWidth: .infinity, alignment: .leading)
                    Text("Best").bold().frame(width: 70)
                    Text("Worst").bold().frame(width: 70)
                    Text("Stable").bold().frame(width: 60)
                    Text("In-place").bold().frame(width: 70)
                }
                Divider()
                ForEach(sortingData, id: \ .algorithm) { item in
                    HStack {
                        Text(item.algorithm).frame(maxWidth: .infinity, alignment: .leading)
                        Text(item.best).frame(width: 70)
                        Text(item.worst).frame(width: 70)
                        Text(item.stable).frame(width: 60)
                        Text(item.inPlace).frame(width: 70)
                    }
                }
            }
            .font(.system(size: 14, design: .monospaced))
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Group {
                Text("Tips")
                    .font(.headline)
                Text("- Visualize recursion with trees.")
                Text("- Use dry runs to debug base/recursive cases.")
                Text("- Merge sort is efficient but not in-place.")
                Text("- Quick sort is fast in practice.")
                Text("- Insertion sort is good for small or nearly sorted arrays.")
            }

            Divider().padding(.vertical, 10)

            Text("Summary")
                .font(.headline)

            VStack(alignment: .leading, spacing: 6) {
                Text("- Understand recursion types and use cases")
                Text("- Learn backtracking approach for problem solving")
                Text("- Practice multiple sorting algorithms")
                Text("- Evaluate time-space trade-offs")
                Text("- Apply optimal sorting based on input and size")
            }
        }
    }
}
