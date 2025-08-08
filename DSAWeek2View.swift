import SwiftUI

struct DSAWeek2View: View {
    let userID: Int
    @State private var navigateToQuiz = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text("📘 Week 2: Arrays, Lists, and String Manipulation")
                    .font(.largeTitle.bold())
                    .foregroundColor(.themePurple)
                    .padding(.top)

                Group {
                    SectionHeader("🔍 Arrays – The Basics")
                    Paragraph("An array is a data structure used to store multiple values in a single variable. Arrays have a fixed size and support random access.")

                    BulletPoints([
                        "Declaration and Initialization",
                        "Index-based access",
                        "Time complexity: Access O(1), Insertion/Deletion O(n)",
                        "Use cases: Static datasets, fixed memory layout"
                    ])

                    CodeBlock("""
                    var arr = [1, 2, 3, 4, 5]
                    print(arr[2]) // Outputs: 3
                    """)

                    SectionHeader("🔁 List – Swift ArrayList Equivalent")
                    Paragraph("Lists in other languages like Python (List), Java (ArrayList), or C++ (vector) are dynamic arrays that resize automatically.")

                    BulletPoints([
                        "Resizable",
                        "Dynamic memory allocation",
                        "Useful for variable-sized collections"
                    ])
                }

                Group {
                    SectionHeader("🔤 String Manipulation")
                    Paragraph("Strings are sequences of characters. In DSA, common problems include reversal, palindrome check, substring search, etc.")

                    BulletPoints([
                        "Reversing strings",
                        "Checking for palindromes",
                        "Pattern matching",
                        "Anagram checks"
                    ])

                    CodeBlock("""
                    let str = "racecar"
                    print(String(str.reversed()) == str) // true: it's a palindrome
                    """)
                }

                Group {
                    SectionHeader("📈 Time and Space Complexity")
                    Paragraph("Understanding how much time and space an algorithm takes is key to writing efficient code.")

                    BulletPoints([
                        "Time complexity measures execution time (e.g. O(n), O(log n))",
                        "Space complexity measures additional memory used",
                        "Big O Notation: Worst-case scenario",
                        "Helps evaluate scalability"
                    ])

                    CodeBlock("""
                    // Linear search - Time: O(n)
                    func linearSearch(arr: [Int], target: Int) -> Bool {
                        for num in arr {
                            if num == target {
                                return true
                            }
                        }
                        return false
                    }
                    """)
                }

                Group {
                    SectionHeader("🧠 Practice Problems")

                    Paragraph("1. Reverse a String")
                    CodeBlock("""
                    func reverse(_ s: String) -> String {
                        return String(s.reversed())
                    }
                    """)

                    Paragraph("2. Find the Maximum Element in Array")
                    CodeBlock("""
                    func findMax(_ arr: [Int]) -> Int? {
                        return arr.max()
                    }
                    """)

                    Paragraph("3. Check if Two Strings are Anagrams")
                    CodeBlock("""
                    func areAnagrams(_ s1: String, _ s2: String) -> Bool {
                        return s1.sorted() == s2.sorted()
                    }
                    """)

                    Paragraph("4. Find First Unique Character in a String")
                    CodeBlock("""
                    func firstUniqChar(_ s: String) -> Character? {
                        var count: [Character: Int] = [:]
                        for char in s {
                            count[char, default: 0] += 1
                        }
                        for char in s {
                            if count[char] == 1 {
                                return char
                            }
                        }
                        return nil
                    }
                    """)

                    Paragraph("5. Find Missing Number in Array (1 to n)")
                    CodeBlock("""
                    func missingNumber(_ arr: [Int], _ n: Int) -> Int {
                        let expectedSum = n * (n + 1) / 2
                        let actualSum = arr.reduce(0, +)
                        return expectedSum - actualSum
                    }
                    """)
                }

                Group {
                    SectionHeader("💡 Tips for the Week")
                    BulletPoints([
                        "Know the difference between fixed-size arrays and dynamic lists.",
                        "Practice string questions regularly – they're common in interviews.",
                        "Always check edge cases: empty array, one element, duplicate values.",
                        "Understand basic Big-O complexities for common operations."
                    ])

                    SectionHeader("📚 More Learning Links")
                    BulletPoints([
                        "[Array vs List – GeeksforGeeks](https://www.geeksforgeeks.org/difference-between-array-and-arraylist/) ",
                        "[String Problems – Leetcode](https://leetcode.com/problemset/all/?topicSlugs=string)",
                        "[Big-O Cheat Sheet](https://www.bigocheatsheet.com/)"
                    ])

                    LottieView(animationName: "learning_animation", loopMode: .loop)
                        .frame(height: 220)
                        .padding(.vertical)
                }

                Button(action: {
                    navigateToQuiz = true
                }) {
                    Text("🚀 Start Quiz Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.themePurple)
                        .cornerRadius(20)
                }
                .padding(.bottom)
            }
            .padding()
        }
        .navigationTitle("Week 2 - Basics")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white.ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToQuiz) {
            DSAWeek2QuizView(userID: userID)
        }
    }

    // MARK: - Reusable Components

    @ViewBuilder
    func SectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title3.bold())
            .foregroundColor(.themePurple)
            .padding(.top)
    }

    @ViewBuilder
    func Paragraph(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .foregroundColor(.black)
    }

    @ViewBuilder
    func BulletPoints(_ points: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(points, id: \.self) { point in
                HStack(alignment: .top) {
                    Text("•").bold().foregroundColor(.themePurple)
                    Text(point).foregroundColor(.black)
                }
            }
        }
        .font(.body)
    }
    @ViewBuilder
    func CodeBlock(_ code: String) -> some View {
        ScrollView(.horizontal) {
            Text(code)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.black)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
}

