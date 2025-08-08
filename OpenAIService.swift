//
//  OpenAIService.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 24/06/25.
//

//private let apiKey = "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"
import Foundation

class OpenAIService {
    static let shared = OpenAIService()
    private let apiKey = "" // Replace with your real key

    func sendMessage(_ message: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://openrouter.ai/api/v1/chat/completions") else {
            completion("❌ Invalid URL")
            return
        }

        let messages: [[String: String]] = [
            ["role": "system", "content": "You are Milo, a helpful AI interview coach. Give accurate answers and guide the user."],
            ["role": "user", "content": message]
        ]

        let parameters: [String: Any] = [
            "model": "deepseek/deepseek-r1-0528:free",
            "messages": messages,
            "temperature": 0.7
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network Error: \(error.localizedDescription)")
                completion("❌ Network error")
                return
            }

            guard let data = data else {
                completion("❌ No response from server")
                return
            }

            // Decode OpenRouter response
            do {
                let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                if let content = decoded.choices.first?.message.content {
                    completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("❌ Unexpected structure")
                    completion("❌ Unexpected response structure")
                }
            } catch {
                let raw = String(data: data, encoding: .utf8) ?? "Unparsable"
                print("❌ Decode error: \(error.localizedDescription)\n📥 Raw: \(raw)")
                completion("❌ Failed to decode response.")
            }
        }.resume()
    }
}

// MARK: - Response Model
struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}


