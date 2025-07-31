//
//  WelcomeView.swift
//  LexiAI
//
//  Created by Ismail Shirzad  on 2025-07-31.
//


import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Welcome to Lexi AI")
                        .font(.largeTitle)
                        .foregroundColor(.white)

                    NavigationLink(destination: ChatView()) {
                        Text("Start Chatting")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
    }
}
