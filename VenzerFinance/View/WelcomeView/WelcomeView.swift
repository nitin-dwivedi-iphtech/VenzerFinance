//
//  WelcomeView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 18/09/26.
//
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("BackgroundColor").opacity(0.6),
                    Color("BackgroundColor").opacity(0.15),
                    Color("BackgroundColor").opacity(0.3)
                ],
                startPoint: .bottomTrailing,
                endPoint: .topLeading
            )
            .ignoresSafeArea()
            
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
            
            VStack(spacing: 16) {
                header
                welcomeSection
                accountCard
                    .padding(.horizontal, 20)
                Spacer()
            }
        }
    }
    
    var header: some View {
        HStack {
            Text("venzer.")
                .font(.title)
                .bold()
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title3)
                    .foregroundStyle(.black)
            }
            .padding(10)
            .background(.white.opacity(0.67), in: Circle())
            
            Image("image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 42, height: 42)
                .clipShape(Circle())
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Hi Jon Snow,")
                .font(.system(size: 13))
            Text("Welcome Back!")
                .font(.system(size: 35, weight: .light))
            Text("Here's your latest account overview")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
    
    var accountCard: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottom) {
                UnevenRoundedRectangle(
                    topLeadingRadius: 20,
                    topTrailingRadius: 20
                )
                .fill(Color("InsideCarTopColor"))
                .frame(height: 70)
                .overlay(alignment: .top) {
                    HStack(spacing: 2) {
                        Text("Jon Snow")
                            .font(.system(size: 15))
                            .bold()
                            .foregroundStyle(.black)
                        Spacer()
                        Text("PayPal")
                            .font(.system(size: 15))
                            .bold()
                            .italic()
                            .foregroundStyle(.black)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
                .padding(.bottom, 15)
                
                HStack {
                    Text("•••• 0849")
                        .font(.system(size: 15))
                        .foregroundStyle(.black.opacity(0.7))
                    Spacer()
                    Text("VISA")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                }
                .padding(.top, 12)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .background(Color("InsideCarBottomColor"))
                .clipShape(NotchedCardShape(position: .bottom, direction: .inward))
                .offset(y: 20)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 4) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color("InsideCarBottomColor"))
                
                Text("$4,309,573.02")
                    .font(.system(size: 26, weight: .bold))
                
                Text("Total Balance")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.white.opacity(0.3),
                        style: StrokeStyle(
                            lineWidth: 0.5,
                            lineCap: .round,
                            dash: [6, 6]
                        )
                    )
            )
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    Label("Deposit", systemImage: "square.and.arrow.down")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(20)
                }
                
                Button(action: {}) {
                    Label("Send", systemImage: "paperplane.fill")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundStyle(.black)
                        .background(Color.white)
                        .cornerRadius(20)
                }
            }
        }
        .padding(20)
        .background(Color("CardColor"))
        .clipShape(NotchedCardShape(position: .top, direction: .inward))
        .foregroundStyle(.white)
    }
}

#Preview {
    WelcomeView()
}
