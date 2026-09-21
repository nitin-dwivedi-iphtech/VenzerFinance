//
//  SignUpView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import SwiftUI

struct SignUpView:View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name:String = ""
    @State private var country:Country = .india
    @State private var isPasswordVisible: Bool = false
    @Binding var signUp:Bool
    var authViewModel:AuthViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Create Account!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.black)
                
                Text("Sign in to manage your finances")
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
                
                
                CustomTextField(
                    text: $name,
                    prompt: "Enter your name",
                    iconName: "person.fill"
                )
                HStack{
                    Text("Country")
                        .fontWeight(.medium)
                    Spacer()
                    Picker("Select Country", selection: $country) {
                        ForEach(Country.allCases) { item in
                            HStack {
                                Text(item.rawValue)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.black.opacity(0.7))
                            }
                            .tag(item)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.black)
                }
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
                if Helper.isFormValid(for: [email, password, name, country.rawValue]) {
                    authViewModel.createUser(email: email, password: password, name: name, country: country.rawValue)
                }
            }) {
                Text("Sign Up")
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
            
            // Login link
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                Button(action: {}) {
                    Text("Log In")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.black)
                        .onTapGesture {
                            signUp = false
                        }
                }
            }
            .padding(.top, 16)
        }
    }
}


//#Preview {
//    SignUpView(signUp: .constant(true))
//}
