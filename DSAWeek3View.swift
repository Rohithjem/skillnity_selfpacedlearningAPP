//
//  DSAWeek3View.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 16/07/25.
//

import Foundation
import SwiftUI

struct DSAWeek3View: View {
    let userID: Int
    @State private var navigateToQuiz = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("📘 Week 3: Linked List & Pointer-Based Problems")
                    .font(.largeTitle.bold())
                    .foregroundColor(.themePurple)
                    .padding(.top)

                Group {
                    SectionHeader("🔍 What is a Linked List?")
                    Paragraph("""
                    A Linked List is a linear data structure in which elements are stored in nodes, and each node points to the next node in the sequence. Unlike arrays, linked lists do not require contiguous memory and are dynamic in nature.
                    """)

                    SectionHeader("📂 Types of Linked Lists")
                    BulletPoints([
                        "Singly Linked List – Points only to the next node.",
                        "Doubly Linked List – Points to both next and previous nodes.",
                        "Circular Linked List – Last node connects back to head."
                    ])

                    SectionHeader("🧩 Real-World Applications")
                    BulletPoints([
                        "Music player queues or playlists.",
                        "Browser back/forward navigation.",
                        "Undo/redo operations in editors.",
                        "Memory management in operating systems."
                    ])
                }

                Group {
                    SectionHeader("🧠 Why Linked Lists Over Arrays?")
                    BulletPoints([
                        "Dynamic memory allocation – no need for fixed size.",
                        "Efficient insertions/deletions (especially at head/tail).",
                        "No shifting of elements like in arrays.",
                        "Better suited for certain abstract data types (Stacks, Queues)."
                    ])
                }

                Group {
                    SectionHeader("⚙️ Core Operations")
                    BulletPoints([
                        "Insertion – Head, Tail, Middle.",
                        "Deletion – By position or value.",
                        "Traversal – Print all nodes.",
                        "Search – Find an element.",
                        "Reversal – Reverse the entire list."
                    ])
                    
                    SectionHeader("💡 Reversal Explained")
                    Paragraph("One of the most asked problems. Reversal can be done iteratively or recursively.")
                    
                    CodeBlock("""
                    func reverseList(_ head: ListNode?) -> ListNode? {
                        var prev: ListNode? = nil
                        var current = head
                        while current != nil {
                            let next = current?.next
                            current?.next = prev
                            prev = current
                            current = next
                        }
                        return prev
                    }
                    """)
                }

                Group {
                    SectionHeader("📌 Advanced Patterns & Interview Questions")
                    BulletPoints([
                        "Find middle of a Linked List (Tortoise & Hare Algorithm)",
                        "Detect cycle in Linked List (Floyd's Cycle Detection)",
                        "Remove N-th node from the end",
                        "Merge two sorted linked lists",
                        "Palindrome Linked List check"
                    ])
                    
                    SectionHeader("🧮 Tortoise & Hare – Middle Finder")
                    CodeBlock("""
                    func findMiddle(_ head: ListNode?) -> ListNode? {
                        var slow = head
                        var fast = head
                        while fast != nil && fast?.next != nil {
                            slow = slow?.next
                            fast = fast?.next?.next
                        }
                        return slow
                    }
                    """)
                    
                    SectionHeader("🔁 Floyd's Cycle Detection")
                    CodeBlock("""
                    func hasCycle(_ head: ListNode?) -> Bool {
                        var slow = head
                        var fast = head
                        while fast != nil && fast?.next != nil {
                            slow = slow?.next
                            fast = fast?.next?.next
                            if slow === fast { return true }
                        }
                        return false
                    }
                    """)
                }

                Group {
                    SectionHeader("📚 Practice Exercises")
                    BulletPoints([
                        "✅ Insert a node at the beginning",
                        "✅ Delete a node at a given position",
                        "✅ Reverse the linked list",
                        "✅ Check if a list is a palindrome",
                        "✅ Detect and remove a loop",
                        "✅ Merge two sorted lists",
                        "✅ Intersection point of two linked lists",
                        "✅ Flatten a multilevel linked list"
                    ])

                    SectionHeader("🧑‍💻 Code & Visual Demos Coming Soon!")
                    LottieView(animationName: "learning_animation", loopMode: .loop)
                        .frame(height: 220)
                        .padding(.vertical)
                }

                Group {
                    SectionHeader("💡 Tips & Notes")
                    BulletPoints([
                        "Use `fast` and `slow` pointers wisely in linked list questions.",
                        "Recursion is useful but can lead to stack overflow for large lists.",
                        "Always handle edge cases – null head, one node, two nodes.",
                        "Drawing helps! Visualize the list on paper before coding."
                    ])

                    SectionHeader("🛠️ Recommended Practice Links")
                    BulletPoints([
                        "[Reverse Linked List – Leetcode](https://leetcode.com/problems/reverse-linked-list/)",
                        "[Remove Nth Node – Leetcode](https://leetcode.com/problems/remove-nth-node-from-end-of-list/)",
                        "[Linked List Cycle – Leetcode](https://leetcode.com/problems/linked-list-cycle/)",
                        "[Palindrome Linked List – Leetcode](https://leetcode.com/problems/palindrome-linked-list/)"
                    ])
                }

                Divider().padding(.vertical)

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
        .navigationTitle("Week 3 - Linked List")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white.ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToQuiz) {
            DSAWeek3QuizView(userID: userID)
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

