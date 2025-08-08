//
//  AdminCourseListView.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 01/08/25.
//

import Foundation
import SwiftUI


import SwiftUI

struct AdminCourseListView: View {
    @State private var courses: [NewCourse] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @ObservedObject private var appState = AppState.shared

    @State private var showingCreateSheet = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Manage Courses")
                        .font(.title2.bold())
                    Spacer()
                    Button(action: {
                        showingCreateSheet = true
                    }) {
                        Text("+ Add Course")
                            .bold()
                            .padding(8)
                            .background(Color.themePurple)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()

                if isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if let error = errorMessage {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else if courses.isEmpty {
                    Spacer()
                    Text("No courses available. Add a new course to get started.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(courses) { course in
                                NavigationLink(destination: AdminEditCourseView(course: course)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        AsyncImage(url: URL(string: "http://localhost/skillnity\(course.image_url)")) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(height: 100)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            case .failure:
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.1))
                                                    .overlay(Image(systemName: "photo"))
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .frame(height: 100)
                                        .clipped()
                                        .cornerRadius(8)

                                        Text(course.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text(course.description)
                                            .font(.caption)
                                            .lineLimit(2)
                                            .foregroundColor(.gray)

                                        HStack {
                                            Text(course.is_active == 1 ? "Active" : "Inactive")
                                                .font(.caption2)
                                                .padding(4)
                                                .background(course.is_active == 1 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                                .cornerRadius(4)
                                            Spacer()
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        loadCourses()
                    }
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Courses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { loadCourses() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                // For creation, pass a "blank" course. Edit view should handle id==0 as create.
                AdminEditCourseView(course: NewCourse(id: 0, title: "", description: "", image_url: "", is_active: 1, created_at: ""))
                    .onDisappear {
                        loadCourses()
                    }
            }
            .onAppear(perform: loadCourses)
        }
    }
    

    


    private func loadCourses() {
        isLoading = true
        errorMessage = nil
        APIService.shared.fetchNewCourses { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let all):
                    self.courses = all // filter if needed: .filter { $0.is_active == 1 }
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }
}

//struct AdminCourseListView: View {
//    @State private var courses: [NewCourse] = []
//    @State private var isLoading = true
//    @State private var errorMessage: String?
//    @ObservedObject private var appState = AppState.shared
//
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Manage Courses")
//                    .font(.title2.bold())
//                Spacer()
//                NavigationLink(destination: AdminEditCourseView(course: NewCourse(id: 0, title: "", description: "", image_url: "", is_active: 1, created_at: ""))) {
//                    Text("+ Add Course")
//                        .bold()
//                        .padding(8)
//                        .background(Color.themePurple)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//            }
//            .padding()
//
//            if isLoading {
//                ProgressView()
//                    .padding()
//                Spacer()
//            } else if let error = errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//                    .padding()
//                Spacer()
//            } else {
//                ScrollView {
//                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
//                        ForEach(courses) { course in
//                            NavigationLink(destination: AdminEditCourseView(course: course)) {
//                                VStack(alignment: .leading, spacing: 8) {
//                                    AsyncImage(url: URL(string: "http://localhost/skillnity\(course.image_url)")) { phase in
//                                        switch phase {
//                                        case .empty:
//                                            ProgressView()
//                                                .frame(height: 100)
//                                        case .success(let image):
//                                            image
//                                                .resizable()
//                                                .scaledToFill()
//                                        case .failure:
//                                            Rectangle()
//                                                .fill(Color.gray.opacity(0.1))
//                                                .overlay(Image(systemName: "photo"))
//                                        @unknown default:
//                                            EmptyView()
//                                        }
//                                    }
//                                    .frame(height: 100)
//                                    .clipped()
//                                    .cornerRadius(8)
//
//                                    Text(course.title)
//                                        .font(.headline)
//                                        .lineLimit(1)
//                                    Text(course.description)
//                                        .font(.caption)
//                                        .lineLimit(2)
//                                        .foregroundColor(.gray)
//
//                                    HStack {
//                                        Text(course.is_active == 1 ? "Active" : "Inactive")
//                                            .font(.caption)
//                                            .padding(4)
//                                            .background(course.is_active == 1 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
//                                            .cornerRadius(4)
//                                        Spacer()
//                                    }
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(12)
//                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                        }
//                    }
//                    .padding()
//                }
//            }
//        }
//        .background(Color(.systemGroupedBackground).ignoresSafeArea())
//        .onAppear(perform: loadCourses)
//    }
//
//    private func loadCourses() {
//        isLoading = true
//        errorMessage = nil
//        APIService.shared.fetchNewCourses { result in
//            DispatchQueue.main.async {
//                isLoading = false
//                switch result {
//                case .success(let all):
//                    // Optionally filter
//                    self.courses = all
//                case .failure(let err):
//                    self.errorMessage = err.localizedDescription
//                }
//            }
//        }
//    }
//}
