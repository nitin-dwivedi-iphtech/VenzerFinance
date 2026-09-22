//
//  SettingView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 22/09/26.
//

import SwiftUI

struct SettingView: View {
    @StateObject var settingViewModel = SettingViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            header
                .padding()
            
            ScrollView(showsIndicators: false) {
                if settingViewModel.account == nil {
                    accountNotFound
                        .padding()
                }
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        
                        accountManagement
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.white.opacity(0.65), in: CustomCornerShape(corners: [.topLeft, .topRight], radius: 35))
            .ignoresSafeArea(edges: .bottom)
        }
        .background {
            CustomBackgroundView()
        }
    }
    
    private var header: some View {
        HStack {
            Text("Account hub")
                .font(.system(size: 23))
                .fontWeight(.light)
            
            Spacer()
            
            Button(action: {
                authViewModel.logOut()
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.red)
                    .padding(10)
                    .background {
                        Circle()
                            .fill(.white)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                    }
                    .overlay {
                        Circle()
                            .stroke(Color.red.opacity(0.15), lineWidth: 1)
                    }
            }
        }
    }
    
    private var accountNotFound: some View {
        VStack(alignment: .leading) {
            Text("No account connected")
                .font(.system(size: 18))
                .bold()
            
            Text(Constants.accountNotFoundDesc.rawValue)
                .font(.system(size: 14))
                .fontWeight(.light)
                .padding(.vertical, 5)
            
            Button(action: {}) {
                Text("+ Add account")
                    .foregroundStyle(Color("InsideCarBottomColor"))
                    .frame(maxWidth: .infinity)
                    .bold()
            }
            .padding(.vertical, 12)
            .background(Color("CardColor"), in: RoundedRectangle(cornerRadius: 20))
            
            Text("You can add a personal, business, or shared account later")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.vertical, 5)
        }
        .padding()
        .background(Color("InsideCarBottomColor").opacity(0.35), in: RoundedRectangle(cornerRadius: 15))
    }
    
    private var accountManagement: some View {
        VStack(alignment: .leading) {
            Text("Account management")
                .font(.system(size: 18))
                .fontWeight(.bold)
            
            Text(Constants.accountManagementDesc.rawValue)
                .font(.system(size: 12))
                .foregroundStyle(.gray)
                .padding(.bottom, 8)
                .padding(.top, 0.12)
            
            VStack(spacing: 16) {
                personalDetails
                accountDetails
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    private var personalDetails: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Personal details")
                    .font(.system(size: 15))
                    .bold()
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.pencil")
                }
            }
            
            HStack {
                Text("Full name")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
                Spacer()
                Text("-")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
            }
            
            HStack {
                Text("Email")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
                Spacer()
                Text("-")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
            }
            
            HStack {
                Text("Phone")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
                Spacer()
                Text("-")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
            }
        }
        .padding()
        .background(Color("InsideCarBottomColor").opacity(0.25), in: RoundedRectangle(cornerRadius: 15))
    }
    
    private var accountDetails: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Account details")
                    .font(.system(size: 15))
                    .bold()
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.pencil")
                }
            }
            
            HStack {
                Text("Account type")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
                Spacer()
                Text("-")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
            }
            
            HStack {
                Text("Billing email")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
                Spacer()
                Text("-")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
            }
            
            HStack {
                Text("Plan")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
                Spacer()
                Text("-")
                    .font(.system(size: 14))
                    .foregroundStyle(.black.opacity(0.6))
            }
        }
        .padding()
        .background(Color("InsideCarBottomColor").opacity(0.25), in: RoundedRectangle(cornerRadius: 15))
    }
}

struct CustomCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    SettingView()
}
