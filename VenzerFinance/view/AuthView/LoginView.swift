//
//  LoginView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var signUp: Bool
    @Binding var isLoading: Bool

    @EnvironmentObject var authViewModel: AuthViewModel
    @FocusState private var focusedField: Field?

    private enum Field { case email, password }

    var body: some View {
        VStack(spacing: 18) {
            header
            formCard
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color("InsideCarBottomColor").opacity(0.35))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "waveform.path.ecg")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color("CardColor"))
                    )
                Text("Welcome Back!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.black)
                Spacer()
            }
            Text("Sign in to continue managing your finances securely")
                .font(.system(size: 13.5, weight: .regular))
                .foregroundStyle(.gray)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Form Card
    private var formCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                CustomTextField(
                    text: $email,
                    prompt: "Email address",
                    iconName: "envelope.fill"
                )
                .focused($focusedField, equals: .email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)

                CustomTextField(
                    text: $password,
                    prompt: "Password",
                    iconName: "lock.fill",
                    isSecure: true
                )
                .focused($focusedField, equals: .password)
            }

            // Forgot password
            HStack {
                Spacer()
                Button {
                    // TODO: forgot password flow
                } label: {
                    Text("Forgot Password?")
                        .font(.system(size: 12.5, weight: .semibold))
                        .foregroundStyle(Color("CardColor"))
                }
            }

            // Primary CTA
            Button {
                focusedField = nil
                guard Helper.isFormValid(for: [email, password]) else { return }
                withAnimation { isLoading = true }
                // small delay to show loading shimmer that matches app theme
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    _ = authViewModel.loginUser(email: email.trimmingCharacters(in: .whitespaces), password: password)
                    isLoading = false
                }
            } label: {
                HStack(spacing: 8) {
                    Text("Sign In")
                        .font(.system(size: 16, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 13, weight: .bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color("CardColor"))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color("CardColor").opacity(0.25), radius: 10, x: 0, y: 6)
            }
            .buttonStyle(.plain)
            .padding(.top, 4)

            divider

            VStack(spacing: 12) {
                Text("or continue with")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.gray.opacity(0.8))
                    .tracking(0.4)
                    .textCase(.uppercase)

                HStack(spacing: 12) {
                    socialButton(icon: "apple.logo", title: "Apple") {}
                    socialButton(icon: "g.circle.fill", title: "Google") {}
                }
            }
            .padding(.top, 2)

            // Footer
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                Button {
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.8)) {
                        signUp = true
                    }
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color("CardColor"))
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.07), radius: 18, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.9), lineWidth: 1)
        )
    }

    private var divider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.black.opacity(0.06))
                .frame(height: 1)
            Text("OR")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.gray.opacity(0.6))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color("InsideCarTopColor"), in: Capsule())
            Rectangle()
                .fill(Color.black.opacity(0.06))
                .frame(height: 1)
        }
        .padding(.vertical, 4)
    }

    private func socialButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                Text(title)
                    .font(.system(size: 13.5, weight: .semibold))
            }
            .foregroundStyle(.black.opacity(0.85))
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
