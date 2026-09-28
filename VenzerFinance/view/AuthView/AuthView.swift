//
//  AuthView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import SwiftUI
import CoreData

struct AuthView: View {
    @State var signUp: Bool = false
    @State var isLoading: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @Namespace private var switchNamespace
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    brandHeader
                    heroSection
                    switcher
                    Group {
                        if signUp {
                            SignUpView(signUp: $signUp, isLoading: $isLoading)
                                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                        } else {
                            LoginView(signUp: $signUp, isLoading: $isLoading)
                                .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .trailing).combined(with: .opacity)))
                        }
                    }
                    .animation(.spring(response: 0.38, dampingFraction: 0.82), value: signUp)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
            .scrollDismissesKeyboard(.interactively)
            
            if isLoading {
                loadingOverlay
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }
        }
        .animation(.easeInOut(duration: 0.22), value: isLoading)
    }
    
    // Brand header
    private var brandHeader: some View {
        HStack(alignment: .center) {
            Text("venzer.")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.black)
                .tracking(-0.5)
            
            Spacer()
            
            HStack(spacing: 6) {
                Circle()
                    .fill(Color("InsideCarBottomColor"))
                    .frame(width: 6, height: 6)
                Text("Secured • Encrypted")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.gray)
                    .tracking(0.6)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.85), in: Capsule())
            .overlay(Capsule().stroke(Color.black.opacity(0.06), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
    }
    
    private var heroSection: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color("InsideCarTopColor"), Color("InsideCarBottomColor").opacity(0.55)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 148)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.white.opacity(0.7), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
                
                HStack(spacing: 14) {
                    Image("loginImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(Color("CardColor"))
                            Text("BANK-GRADE SECURITY")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color("CardColor").opacity(0.85))
                                .tracking(0.6)
                        }
                        
                        Text("Manage wealth\nwith confidence")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.black.opacity(0.88))
                            .lineSpacing(1)
                        
                        Text("Track, swap & grow — all in one place")
                            .font(.system(size: 11))
                            .foregroundStyle(.black.opacity(0.55))
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 18)
            }
            
            // trust pill
            HStack(spacing: 8) {
                HStack(spacing: -6) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 22, height: 22)
                            .overlay(
                                Image(systemName: ["person.fill","star.fill","heart.fill"][i % 3])
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(Color("CardColor").opacity(0.85))
                            )
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
                Text("Trusted by 12,000+ members")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.gray)
                Spacer()
                HStack(spacing: 3) {
                    Image(systemName: "star.fill").font(.system(size: 9)).foregroundStyle(Color.orange.opacity(0.9))
                    Text("4.9")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.black.opacity(0.8))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color("InsideCarBottomColor").opacity(0.35), in: Capsule())
            }
            .padding(.horizontal, 4)
        }
    }
    
    //Segmented switcher
    private var switcher: some View {
        HStack(spacing: 0) {
            ForEach([false, true], id: \.self) { isSignUp in
                let title = isSignUp ? "Create Account" : "Sign In"
                let selected = (signUp == isSignUp)
                
                Button {
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
                        signUp = isSignUp
                    }
                } label: {
                    Text(title)
                        .font(.system(size: 13.5, weight: .semibold))
                        .foregroundStyle(selected ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                        .background {
                            if selected {
                                Capsule()
                                    .fill(Color("CardColor"))
                                    .shadow(color: Color("CardColor").opacity(0.28), radius: 8, x: 0, y: 4)
                                    .matchedGeometryEffect(id: "AUTH_SWITCH", in: switchNamespace)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
                .overlay(Capsule().stroke(Color.black.opacity(0.05), lineWidth: 1))
        )
        .padding(.vertical, 2)
    }
    
    // Loading overlay
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()
                .background(.ultraThinMaterial.opacity(0.35))
            
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color("CardColor").opacity(0.12))
                        .frame(width: 56, height: 56)
                    ProgressView()
                        .tint(Color.white)
                        .scaleEffect(1.15)
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 22)
            .padding(.horizontal, 50)
        }
    }
}

#Preview {
    AuthView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(AuthViewModel(context: PersistenceController.shared.container.viewContext))
        .background { CustomBackgroundView() }
}
