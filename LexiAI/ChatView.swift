//
//  ChatView.swift
//  LexiAI
//
//  Created by Ismail Shirzad  on 2025-07-31.
//
import SwiftUI

struct Message: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatView: View {
    @State private var messages: [Message] = [
        Message(text: "Hi! I'm Lexi 🤖", isUser: false),
        Message(text: "How can I help you today?", isUser: false)
    ]
    @State private var userInput: String = ""
    @State private var isTyping = false  // For typing indicator

    let api = OpenRouterAPI()  // API instance

    var body: some View {
        ZStack {
            // Neon purple-blue gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 85/255, green: 0/255, blue: 170/255).opacity(0.8),
                    Color(red: 0/255, green: 102/255, blue: 204/255).opacity(0.7),
                    Color(red: 25/255, green: 0/255, blue: 102/255).opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                ScrollViewReader { scrollView in
                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(messages) { message in
                                HStack {
                                    if message.isUser {
                                        Spacer()

                                        Text(message.text)
                                            .padding(14)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color.blue.opacity(0.3))
                                                    .background(BlurView(style: .systemMaterial))
                                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                                            )
                                            .foregroundColor(.white)
                                            .frame(maxWidth: 250, alignment: .trailing)
                                    } else {
                                        Text(message.text)
                                            .padding(14)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color.white.opacity(0.3))
                                                    .background(BlurView(style: .systemUltraThinMaterial))
                                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                                            )
                                            .foregroundColor(.primary)
                                            .frame(maxWidth: 250, alignment: .leading)

                                        Spacer()
                                    }
                                }
                                .id(message.id)
                            }

                            if isTyping {
                                HStack {
                                    Text("Lexi is typing...")
                                        .italic()
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(14)
                                        .background(Color.black.opacity(0.3))
                                        .cornerRadius(15)

                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _ in
                        if let lastMessage = messages.last {
                            withAnimation {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // Input area with glassy background
                HStack {
                    TextField("Type a message...", text: $userInput)
                        .padding(14)
                        .background(BlurView(style: .systemMaterial))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)

                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 24))
                            .foregroundColor(userInput.isEmpty ? .gray : .blue)
                            .padding(14)
                    }
                    .disabled(userInput.isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .navigationTitle("Lexi AI")
        .navigationBarTitleDisplayMode(.inline)
    }

    func sendMessage() {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messages.append(Message(text: trimmed, isUser: true))
        userInput = ""
        isTyping = true

        api.sendMessage(trimmed) { result in
            DispatchQueue.main.async {
                isTyping = false
                switch result {
                case .success(let response):
                    messages.append(Message(text: response, isUser: false))
                case .failure(let error):
                    messages.append(Message(text: "Error: \(error.localizedDescription)", isUser: false))
                }
            }
        }
    }
}

// UIKit blur effect wrapped for SwiftUI
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

