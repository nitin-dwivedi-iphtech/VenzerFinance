//
//  LoginView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//
import SwiftUI

struct LoginView:View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @Binding var signUp:Bool
    @Binding var isLoading:Bool
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome Back!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.black)
                
                Text("Sign in to continue managing your finances")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Form fields
            VStack(spacing: 16) {
                CustomTextField(
                    text: $email,
                    prompt: "Enter your email",
                    iconName: "envelope.fill"
                )
                
                // Password Input Field
                HStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16))
                    
                    Group {
                        if isPasswordVisible {
                            TextField("Enter your password", text: $password)
                        } else {
                            SecureField("Enter your password", text: $password)
                        }
                    }
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
            }
            
            // Forgot password button
            Button(action: {}) {
                Text("Forgot Password?")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            // Signin button
            Button(action: {
                isLoading = true
                if Helper.isFormValid(for:[email, password]) {
                    authViewModel.loginUser(email: email, password: password)
                }
                isLoading = false
            }) {
                Text("Sign In")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color("CardColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
            }
            .padding(.top, 8)   
            
            // Divider
            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                Text("OR")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.gray)
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.vertical, 8)
            
            // Social login buttons
            HStack(spacing: 16) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 18))
                        Text("Apple")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .font(.system(size: 18))
                        Text("Google")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                }
            }
            
            // Signup link
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                Button(action: {}) {
                    Text("Sign Up")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.black)
                        .onTapGesture {
                            signUp = true
                        }
                }
            }
            .padding(.top, 16)
        }
    }
    
    
}

//#Preview {
//    LoginView(signUp: .constant(false))
//}
