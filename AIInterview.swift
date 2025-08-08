//
//  AIInterview.swift
//  SelfPacedLearningApp
//
//  Created by SAIL on 31/05/25.
//

import Foundation

import SwiftUI
import Lottie

struct AInterviewView: View {
    @State private var selectedMode: InterviewMode = .practice
    @State private var chatHistory: [ChatMessage] = []
    @State private var userInput: String = ""
    @State private var isTyping = false

    var body: some View {
        VStack(spacing: 0) {
            topBar
            modeTabs

            Divider()

            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(chatHistory) { message in
                            ChatBubble(message: message)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }

                        if isTyping {
                            TypingIndicator()
                        }
                    }
                    .padding()
                    .onChange(of: chatHistory.count) { _ in
                        withAnimation {
                            scrollProxy.scrollTo(chatHistory.last?.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            bottomInputBar
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    @Environment(\.dismiss) private var dismiss

    private var topBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.themePurple)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
            }

            LottieView(animationName: "ai_avatar", loopMode: .loop)
                .frame(width: 50, height: 50)
                .clipShape(Circle())

            Text("Milo – Your AI Interviewer")
                .font(.title3).bold()
                .foregroundColor(.themePurple)

            Spacer()
        }
        .padding()
    }

    private var modeTabs: some View {
        HStack {
            ForEach(InterviewMode.allCases, id: \.self) { mode in
                Button(action: {
                    selectedMode = mode
                    chatHistory = []
                }) {
                    Text(mode.title)
                        .font(.subheadline).bold()
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(mode == selectedMode ? Color.themePurple.opacity(0.2) : Color(.systemGray6))
                        .cornerRadius(10)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var bottomInputBar: some View {
        HStack {
            TextField("Type your message...", text: $userInput)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            Button(action: handleSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.themePurple)
                    .clipShape(Circle())
            }
        }
        .padding()
    }

    private func handleSend() {
        guard !userInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let userMessage = ChatMessage(role: .user, content: userInput)
        chatHistory.append(userMessage)
        isTyping = true
        let currentInput = userInput
        userInput = ""

        // 🔗 Call OpenAIService
        OpenAIService.shared.sendMessage(currentInput) { response in
            DispatchQueue.main.async {
                let botMessage = ChatMessage(role: .bot, content: response ?? "Sorry, I couldn't understand that.")
                chatHistory.append(botMessage)
                isTyping = false
            }
        }
    }

}

// MARK: - Supporting Types

enum InterviewMode: String, CaseIterable {
    case practice, interview

    var title: String {
        switch self {
        case .practice: return "Practice Mode"
        case .interview: return "Interview Mode"
        }
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: MessageRole
    let content: String
}

enum MessageRole {
    case user, bot
}

// ChatBubble.swift
struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom) {
            if message.role == .bot {
                LottieView(animationName: "ai_avatar", loopMode: .loop)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                Text(message.content)
                    .padding(10)
                    .background(Color.themePurple.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundColor(.black)
                Spacer()
            } else {
                Spacer()
                Text(message.content)
                    .padding(10)
                    .background(Color.themePurple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
        .id(message.id)
    }
}

// TypingIndicator.swift
struct TypingIndicator: View {
    var body: some View {
        HStack(spacing: 8) {
            LottieView(animationName: "typing_dots", loopMode: .loop)
                .frame(width: 40, height: 20) // ✅ Smaller, appropriate size
                .padding(.vertical, 4)

//            Text("Milo is typing...")
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding(.horizontal)
    }
}

struct AI_preview: PreviewProvider {
    static var previews: some View {
        AInterviewView()
    }
}
struct LottieView: UIViewRepresentable {
    var animationName: String
    var loopMode: LottieLoopMode = .loop

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: animationName)

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()

        // Add to container view
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
