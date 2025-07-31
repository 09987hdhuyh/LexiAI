//
//  SplashView.swift
//  LexiAI
//
//  Created by Ismail Shirzad  on 2025-07-31.
//


import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.0

    var body: some View {
        if isActive {
            NavigationView {
                ChatView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            ZStack {
                // Neon purple-blue gradient background (same as ChatView)
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

                Text("LexiAI 🤖")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(opacity)
            }
            .onAppear {
                withAnimation(.easeIn(duration: 1.5)) {
                    opacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
