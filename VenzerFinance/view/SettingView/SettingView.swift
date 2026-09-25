//
//  SettingView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 22/09/26.
//
//
import SwiftUI
import CoreData

struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Account hub").font(.system(size: 22, weight: .bold)).foregroundColor(.black)
                    Text("Manage profile & billing").font(.system(size: 12)).foregroundColor(.gray)
                }
                Spacer()
                Button { authViewModel.logOut() } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "rectangle.portrait.and.arrow.forward").font(.system(size: 13, weight: .bold))
                        Text("Logout").font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 14).padding(.vertical, 9)
                    .background(Color.white, in: Capsule())
                    .overlay(Capsule().stroke(Color.red.opacity(0.12), lineWidth: 1))
                }
            }
            .padding()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // hero with user and account
                    ProfileHeroCard(viewModel: viewModel)
                    AccountStatusCard(viewModel: viewModel)
                    PersonalDetailsCard(user: viewModel.user, viewModel: viewModel)
                    AccountDetailsCard(user: viewModel.user, account: viewModel.account, viewModel: viewModel)
                    PreferencesCard(user: viewModel.user)
                    AppVersionFooter()
                }
                .padding(.horizontal, 16)
                .padding(.top, 18)
                .padding(.bottom, 110)
            }
            .background(Color.white.opacity(0.72).clipShape(CustomCornerShape(corners: [.topLeft, .topRight], radius: 32)))
            .ignoresSafeArea(edges: .bottom)
        }
        .background { CustomBackgroundView() }
        
        .onAppear {
            viewModel.refresh()
        }
    }
}

#Preview {
    SettingView().environmentObject(AuthViewModel(context: PersistenceController.shared.container.viewContext))
}
