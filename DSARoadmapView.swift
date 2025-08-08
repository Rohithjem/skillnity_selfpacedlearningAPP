//
//  DSARoadmapView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 04/07/25.
//

import Foundation
import SwiftUI

import SwiftUI

struct DSARoadmapView: View {
    @State private var goHome = false
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 6) {
                    Text("Your Learning Path")
                        .font(.title2.bold())
                        .foregroundColor(.black)

                    Text("5 Weeks to Master DSA")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                Image("DSA-INTRO")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .padding(.horizontal)

                VStack(spacing: 20) {
                    roadmapCard(week: "Week 1", title: "Foundations", subtitle: "Master the basics of Data Structures", icon: "book", color: .blue)
                    roadmapCard(week: "Week 2", title: "Problem Solving", subtitle: "Learn strategic problem-solving approaches", icon: "lightbulb", color: .purple)
                    roadmapCard(week: "Week 3", title: "Algorithms", subtitle: "Explore fundamental algorithms", icon: "chevron.left.slash.chevron.right", color: .pink)
                    roadmapCard(week: "Week 4", title: "Advanced DSA", subtitle: "Deep dive into complex structures", icon: "server.rack", color: .indigo)
                    roadmapCard(week: "Week 5", title: "Final Project & Quiz", subtitle: "Put your skills to the test", icon: "trophy", color: .green)
                }
                .padding(.horizontal)

                Button(action: {
                    goHome = true
                    // You can handle quiz/project launching here
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [.themePurple, .purple], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }

                Text("Let's begin your learning journey!")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $goHome) {
            NavigationStack {
                HomeView(userID: AppState.shared.userID ?? 0,
                         username: AppState.shared.username ?? "User")
            }
        }
    }

    func roadmapCard(week: String, title: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(10)
                .background(color)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                Text(week)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
