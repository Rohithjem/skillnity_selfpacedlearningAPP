////
////  CodingBattleView.swift
////  SelfPacedLearningApp
////
////  Created by SAIL on 05/08/25.
////
//
//import Foundation
//import SwiftUI
//
//struct CodingBattleView: View {
//    @State private var selectedLanguage = "Python"
//    @State private var code = "print(\"Hello World\")"
//    @State private var output = ""
//    @State private var isLoading = false
//
//    let languages = ["Python", "C++", "JavaScript"]
//    let languageMap: [String: Int] = [
//        "C++": 54,
//        "Python": 71,
//        "JavaScript": 63
//    ]
//
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading, spacing: 16) {
//                Text("Coding Battles")
//                    .font(.title)
//                    .bold()
//
//                Picker("Language", selection: $selectedLanguage) {
//                    ForEach(languages, id: \.self) { lang in
//                        Text(lang)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//
//                Text("Code")
//                    .font(.headline)
//
//                TextEditor(text: $code)
//                    .font(.system(.body, design: .monospaced))
//                    .frame(height: 200)
//                    .padding()
//                    .background(Color(.secondarySystemBackground))
//                    .cornerRadius(12)
//
//                Button(action: runCode) {
//                    HStack {
//                        if isLoading {
//                            ProgressView()
//                        }
//                        Text("Run Code")
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//
//                Text("Output")
//                    .font(.headline)
//
//                ScrollView {
//                    Text(output)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding()
//                        .background(Color(.secondarySystemBackground))
//                        .cornerRadius(12)
//                }
//
//                Spacer()
//            }
//            .padding()
//        }
//    }
//
//    func runCode() {
//        isLoading = true
//        output = ""
//
//        guard let langId = languageMap[selectedLanguage] else { return }
//
//        let submission: [String: Any] = [
//            "language_id": langId,
//            "source_code": code
//        ]
//
//
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: submission) else {
//            output = "Failed to encode request"
//            isLoading = false
//            return
//        }
//
//        var request = URLRequest(url: URL(string: "https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=false&wait=true")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("3f77316930mshe3e1297c8c19413p12f461jsn6411f63ed8ab", forHTTPHeaderField: "X-RapidAPI-Key")
//        request.addValue("judge0-ce.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
//        request.httpBody = jsonData
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                isLoading = false
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    output = "No response from server"
//                }
//                return
//            }
//
//            if let result = try? JSONDecoder().decode(Judge0Response.self, from: data) {
//                DispatchQueue.main.async {
//                    output = result.stdout ?? result.compile_output ?? "No output"
//                }
//            } else {
//                DispatchQueue.main.async {
//                    output = "Failed to decode response"
//                }
//            }
//        }.resume()
//    }
//}
//
//struct Judge0Response: Codable {
//    let stdout: String?
//    let compile_output: String?
//    let stderr: String?
//}
import SwiftUI

struct CodingBattleView: View {
    @State private var selectedLanguage = "Python"
    @State private var code = "print(\"Hello World\")"
    @State private var output = ""
    @State private var isLoading = false

    let languages = ["Python", "C++", "Java"]
    let languageMap: [String: Int] = [
        "C++": 54,
        "Python": 71,
        "Java": 62
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("⚔️ Coding Battles")
                        .font(.largeTitle.bold())
                        .padding(.bottom, 5)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Language")
                            .font(.headline)

                        Picker("Language", selection: $selectedLanguage) {
                            ForEach(languages, id: \.self) { lang in
                                Text(lang)
                                    .tag(lang)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 4)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Write Your Code")
                            .font(.headline)

                        TextEditor(text: $code)
                            .font(.system(.body, design: .monospaced))
                            .frame(height: 200)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.purple.opacity(0.5), lineWidth: 1)
                            )
                            .cornerRadius(12)
                    }

                    Button(action: runCode) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                            Text("🚀 Run Code")
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Output")
                            .font(.headline)

                        Text(output.isEmpty ? "Your result will appear here..." : output)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Coding Battles")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func runCode() {
        isLoading = true
        output = ""

        guard let langId = languageMap[selectedLanguage] else { return }

        let submission: [String: Any] = [
            "language_id": langId,
            "source_code": code
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: submission) else {
            output = "Failed to encode request"
            isLoading = false
            return
        }

        var request = URLRequest(url: URL(string: "https://judge0-ce.p.rapidapi.com/submissions?base64_encoded=false&wait=true")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("YOUR API KEY", forHTTPHeaderField: "X-RapidAPI-Key")
        request.addValue("judge0-ce.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    output = "No response from server"
                }
                return
            }

            if let result = try? JSONDecoder().decode(Judge0Response.self, from: data) {
                DispatchQueue.main.async {
                    output = result.stdout ?? result.compile_output ?? result.stderr ?? "No output"
                }
            } else {
                DispatchQueue.main.async {
                    output = "Failed to decode response"
                }
            }
        }.resume()
    }
}

struct Judge0Response: Codable {
    let stdout: String?
    let compile_output: String?
    let stderr: String?
}
