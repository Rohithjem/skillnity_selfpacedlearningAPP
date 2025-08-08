//
//  DSAWeek5View.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 16/07/25.
//

import Foundation
import SwiftUI

struct DSAWeek5View: View {
    let userID: Int
    @State private var navigateToQuiz = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("📘 Week 5: Graphs and Trees")
                    .font(.title.bold())
                    .padding(.top)

                Text("This week covers:")
                    .font(.headline)
                    .foregroundColor(.themePurple)

                VStack(alignment: .leading, spacing: 10) {
                    Text("✅ Introduction to Trees and Graphs")
                    Text("✅ Tree Traversals")
                    Text("✅ Binary Search Trees")
                    Text("✅ Graph Representations")
                    Text("✅ BFS and DFS Traversals")
                    Text("✅ Real-world Applications")
                }
                .font(.subheadline)
                .foregroundColor(.black)

                Divider().padding(.vertical)

                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {

                        // MARK: - Trees Section
                        Text("🌳 Trees in DSA:")
                            .font(.title2.bold())

                        Group {
                            Text("A Tree is a non-linear, hierarchical data structure consisting of nodes connected by edges. It is used to represent relationships in a hierarchical manner.")
                            Text("\nEach tree has a **root node**, and every child node has exactly one parent, except the root node which has none.")
                            Text("\nCommon Tree Types:")
                            Text("- **Binary Tree**: A tree in which each node has at most two children.")
                            Text("- **Binary Search Tree (BST)**: A binary tree in which the left subtree contains only nodes with values less than the parent node and the right subtree contains only nodes with values greater than the parent node.")
                            Text("- **AVL Trees**: Self-balancing binary search trees where the height difference between left and right subtrees is at most 1.")
                            Text("- **N-ary Tree**: A tree in which a node can have more than two children.")
                        }

                        Text("🧭 Tree Traversals:")
                            .font(.headline)

                        Group {
                            Text("Tree traversals are methods to visit all nodes in a tree in a particular order.")
                            Text("- **Inorder Traversal (Left, Root, Right)**: Used in BSTs to get sorted order of elements.")
                            Text("- **Preorder Traversal (Root, Left, Right)**: Useful for creating a copy of the tree.")
                            Text("- **Postorder Traversal (Left, Right, Root)**: Used to delete the tree or evaluate postfix expressions.")
                            Text("- **Level Order Traversal (Breadth-First Search)**: Visits nodes level by level using a queue.")
                        }

                        Text("🔧 Sample Code – Inorder Traversal (Recursive):")
                            .font(.subheadline)

                        Text("""
                        func inorder(_ root: TreeNode?) {
                            guard let node = root else { return }
                            inorder(node.left)
                            print(node.val)
                            inorder(node.right)
                        }
                        """)
                        .font(.system(.body, design: .monospaced))
                        .padding(.leading, 10)

                        Text("🌟 Real-world Uses of Trees:")
                        Group {
                            Text("- File system hierarchy")
                            Text("- DOM in HTML/XML")
                            Text("- Organization charts")
                            Text("- Decision trees in AI")
                            Text("- Compiler syntax trees")
                        }

                        Divider().padding(.vertical, 10)

                        // MARK: - Graphs Section
                        Text("🔗 Graphs in DSA:")
                            .font(.title2.bold())

                        Group {
                            Text("A Graph is a collection of nodes (vertices) and connections (edges) that represent relationships between entities.")
                            Text("\nTypes of Graphs:")
                            Text("- **Undirected Graph**: Edges have no direction.")
                            Text("- **Directed Graph (Digraph)**: Edges point from one vertex to another.")
                            Text("- **Weighted Graph**: Edges carry a weight or cost.")
                            Text("- **Unweighted Graph**: All edges are equal.")
                            Text("\nRepresentation:")
                            Text("- **Adjacency List**: Efficient in space, best for sparse graphs.")
                            Text("- **Adjacency Matrix**: Fast lookups, but uses more space.")
                        }

                        Text("🧭 Graph Traversals:")
                            .font(.headline)

                        Group {
                            Text("- **DFS (Depth-First Search)**: Goes as deep as possible, uses a stack (implicitly via recursion).")
                            Text("- **BFS (Breadth-First Search)**: Visits all neighbors first, uses a queue. Good for finding shortest path in unweighted graphs.")
                        }

                        Text("🔧 Sample Code – BFS Traversal:")
                            .font(.subheadline)

                        Text("""
                        func bfs(start: Int, adj: [[Int]]) {
                            var visited = Array(repeating: false, count: adj.count)
                            var queue = [start]
                            visited[start] = true

                            while !queue.isEmpty {
                                let node = queue.removeFirst()
                                print(node)

                                for neighbor in adj[node] {
                                    if !visited[neighbor] {
                                        visited[neighbor] = true
                                        queue.append(neighbor)
                                    }
                                }
                            }
                        }
                        """)
                        .font(.system(.body, design: .monospaced))
                        .padding(.leading, 10)

                        Text("⚠️ Common Graph Problems:")
                        Group {
                            Text("- Cycle detection")
                            Text("- Connected components")
                            Text("- Topological sorting")
                            Text("- Shortest path algorithms (Dijkstra’s, Bellman-Ford, BFS)")
                            Text("- Graph coloring")
                        }

                        Text("🌍 Real-world Applications:")
                        Group {
                            Text("- Google Maps and GPS navigation")
                            Text("- Web crawling and indexing")
                            Text("- Social networking (friend suggestions, connections)")
                            Text("- Network packet routing")
                            Text("- AI pathfinding (game maps)")
                        }

                        Divider().padding(.vertical, 10)

                        // MARK: - Tips & Tricks
                        Text("💡 Tips & Tricks:")
                            .font(.headline)

                        Group {
                            Text("- Practice drawing tree and graph diagrams to visualize connections.")
                            Text("- For tree problems, recursion is usually the key.")
                            Text("- In graphs, always track visited nodes to prevent infinite loops.")
                            Text("- Know when to use BFS (shortest path) and when to use DFS (exploration).")
                            Text("- Use adjacency list for efficient space in large graphs.")
                        }

                        Divider().padding(.vertical, 10)

                        // MARK: - Summary
                        Text("📌 Summary:")
                            .font(.headline)

                        Text("""
                        Week 5 focuses on advanced data structures like Trees and Graphs.
                        Trees are perfect for hierarchical data, while graphs help model relationships and networks.
                        You’ll learn various traversal techniques and solve real-world algorithmic problems by applying these concepts.
                        These are crucial for interviews, competitive coding, and scalable system designs.
                        """)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 3)

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
        .navigationTitle("Week 5 - Graphs and Trees")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white.ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToQuiz) {
            DSAWeek5QuizView(userID: userID)
        }
    }
}
