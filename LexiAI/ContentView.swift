//
//  ContentView.swift
//  LexiAI
//
//  Created by Ismail Shirzad  on 2025-07-31.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack {
                Text("Welcome to ChatBuddy 🤖")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()

                Text("Your AI assistant is ready to chat.")
                    .foregroundColor(.white)
                    .padding()

                Spacer()

                NavigationLink("Start Chatting") {
                    ChatView()
                }
                .font(.title2)
                .padding()
                .background(Color.white)
                .foregroundColor(.blue)
                .cornerRadius(12)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    ContentView()
}
