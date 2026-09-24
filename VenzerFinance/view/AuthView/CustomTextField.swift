//
//  CustomTextField.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var prompt: String
    var iconName: String? = nil
    var isSecure: Bool = false

    @FocusState private var isFocused: Bool
    @State private var isVisible: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            if let iconName {
                ZStack {
                    Circle()
                        .fill(Color("InsideCarBottomColor").opacity(0.18))
                        .frame(width: 30, height: 30)
                    Image(systemName: iconName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color("CardColor").opacity(0.9))
                }
            }

            Group {
                if isSecure && !isVisible {
                    SecureField("", text: $text, prompt: Text(prompt).foregroundColor(.gray.opacity(0.55)))
                        .font(.system(size: 15))
                        .foregroundStyle(.black)
                        .focused($isFocused)
                        .textContentType(isSecure ? .password : .none)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                } else {
                    TextField("", text: $text, prompt: Text(prompt).foregroundColor(.gray.opacity(0.55)))
                        .font(.system(size: 15))
                        .foregroundStyle(.black)
                        .focused($isFocused)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                }
            }

            if isSecure {
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { isVisible.toggle() }
                } label: {
                    Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray.opacity(0.7))
                        .frame(width: 28, height: 28)
                        .background(Color.black.opacity(0.04), in: Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isFocused ? Color("CardColor").opacity(0.35) : Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(isFocused ? 0.08 : 0.05), radius: isFocused ? 10 : 8, x: 0, y: 4)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.15).ignoresSafeArea()
        
        CustomTextField(
            text: .constant(""),
            prompt: "Search transactions...",
            iconName: "magnifyingglass"
        )
        .padding()
    }
}
