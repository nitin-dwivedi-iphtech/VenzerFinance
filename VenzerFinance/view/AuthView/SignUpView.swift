//
//  SignUpView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import SwiftUI

struct SignUpView: View {

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var country: Country = .india
    @Binding var signUp: Bool
    @Binding var isLoading: Bool

    @EnvironmentObject var authViewModel: AuthViewModel
    @FocusState private var focusedField: Field?

    private enum Field { case name, email, password }

    var body: some View {
        VStack(spacing: 18) {
            header
            formCard
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ZStack {
                    Circle().fill(Color("InsideCarBottomColor").opacity(0.35)).frame(width: 36, height: 36)
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color("CardColor"))
                }
                Text("Create Account")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.black)
                Spacer()
            }
            Text("Join Venzer — smart wealth management for everyone")
                .font(.system(size: 13.5))
                .foregroundStyle(.gray)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var formCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                CustomTextField(text: $name, prompt: "Full name", iconName: "person.fill")
                    .focused($focusedField, equals: .name)
                    .textContentType(.name)

                CustomTextField(text: $email, prompt: "Email address", iconName: "envelope.fill")
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)

                CustomTextField(text: $password, prompt: "Create password", iconName: "lock.fill", isSecure: true)
                    .focused($focusedField, equals: .password)

                countryField
            }

            // Terms hint
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(Color("InsideCarBottomColor"))
                    .padding(.top, 2)
                Text("By creating an account you agree to our Terms & Privacy Policy")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
                    .lineSpacing(1.2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 2)

            Button {
                focusedField = nil
                guard Helper.isFormValid(for: [email, password, name, country.rawValue]) else { return }
                withAnimation { isLoading = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    _ = authViewModel.createUser(email: email.trimmingCharacters(in: .whitespaces), password: password, name: name.trimmingCharacters(in: .whitespaces), country: country.rawValue)
                    isLoading = false
                }
            } label: {
                HStack(spacing: 8) {
                    Text("Create Account")
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
            .padding(.top, 2)

            divider

            VStack(spacing: 12) {
                Text("or sign up with")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.gray.opacity(0.8))
                    .tracking(0.4)
                    .textCase(.uppercase)
                HStack(spacing: 12) {
                    socialButton(icon: "apple.logo", title: "Apple") {}
                    socialButton(icon: "g.circle.fill", title: "Google") {}
                }
            }

            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                Button {
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.8)) { signUp = false }
                } label: {
                    Text("Sign In")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color("CardColor"))
                }
            }
            .padding(.top, 4)
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

    private var countryField: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color("InsideCarBottomColor").opacity(0.18)).frame(width: 30, height: 30)
                Image(systemName: "globe")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color("CardColor").opacity(0.9))
            }

            Text("Country")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.black.opacity(0.75))

            Spacer()

            Menu {
                Picker("Select Country", selection: $country) {
                    ForEach(Country.allCases) { item in
                        Label(item.rawValue.capitalized, image: item.flagImageName)
                            .tag(item)
                        // Fallback text if image label fails
                        // Text(item.rawValue).tag(item)
                    }
                }
            } label: {
                HStack(spacing: 7) {
                    Image(country.flagImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black.opacity(0.06), lineWidth: 1))

                    Text(country.rawValue.capitalized)
                        .font(.system(size: 13.5, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.85))

                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.gray.opacity(0.7))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color("InsideCarTopColor"), in: Capsule())
                .overlay(Capsule().stroke(Color.black.opacity(0.06), lineWidth: 1))
            }
            .tint(.black)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.black.opacity(0.06), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var divider: some View {
        HStack(spacing: 12) {
            Rectangle().fill(Color.black.opacity(0.06)).frame(height: 1)
            Text("OR")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.gray.opacity(0.6))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color("InsideCarTopColor"), in: Capsule())
            Rectangle().fill(Color.black.opacity(0.06)).frame(height: 1)
        }
        .padding(.vertical, 2)
    }

    private func socialButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 15, weight: .semibold))
                Text(title).font(.system(size: 13.5, weight: .semibold))
            }
            .foregroundStyle(.black.opacity(0.85))
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(Color.black.opacity(0.06), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
