//
//  SplashScreen.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive: Bool = false
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.85
    @State private var isPulsing: Bool = false
    
    var body: some View {
        Group {
            if isActive {
                ContentView()
                    .transition(.opacity)
            } else {
                SubSplashView(opacity: $opacity, scale: $scale, isPulsing: $isPulsing)
            }
        }
        .onAppear {
            // Animate logo entrance
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1.0
                scale = 1.0
            }
            
            // Continuous subtle pulse glow for modern feel
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
            
            // Transition to main screen after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isActive = true
                }
            }
        }
    }
}

struct SubSplashView: View {
    @Binding var opacity: Double
    @Binding var scale: CGFloat
    @Binding var isPulsing: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.clear,
                    Color("BackgroundColor").opacity(0.5),
                    Color("BackgroundColor").opacity(0.15),
                    Color("BackgroundColor").opacity(0.6)
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            
            // Global watermark "V" shapes
            GeometryReader { proxy in
                ZStack {
                    Text("v")
                        .font(.system(size: proxy.size.width * 1.8, weight: .bold))
                        .foregroundColor(Color.black.opacity(0.025))
                        .rotationEffect(.degrees(-261))
                        .offset(
                            x: proxy.size.width * 0.85,
                            y: -proxy.size.height * 0.3
                        )
                    
                    Text("v")
                        .font(.system(size: proxy.size.width * 1.8, weight: .bold))
                        .foregroundColor(Color.black.opacity(0.025))
                        .rotationEffect(.degrees(-27))
                        .offset(
                            x: -proxy.size.width * 0.5,
                            y: -proxy.size.height * 0.7
                        )
                }
                .allowsHitTesting(false)
            }
            
            VStack(spacing: 24) {
                
                ZStack {
                    Circle()
                        .fill(Color("CardColor").opacity(0.35))
                        .frame(width: 130, height: 130)
                        .blur(radius: 25)
                        .scaleEffect(isPulsing ? 1.15 : 0.95)
                    
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color.white.opacity(0.75))
                        .frame(width: 110, height: 110)
                        .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.white.opacity(0.9), lineWidth: 1.5)
                        )
                    
                    Image(systemName: "wallet.bifold.fill")
                        .font(.system(size: 50, weight: .semibold))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.black.opacity(0.85), Color("CardColor"))
                }
                
                VStack(spacing: 6) {
                    Text("Venzer Finance")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.black.opacity(0.9))
                    
                    Text("Smart wealth management")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray)
                        .tracking(0.5)
                }
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
    }
}

#Preview {
    SplashScreen()
}
