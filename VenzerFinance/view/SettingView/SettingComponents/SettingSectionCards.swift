//
//  SettingSectionCards.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//

import SwiftUI

struct AccountStatusCard: View {
    
    @ObservedObject var viewModel: SettingViewModel
    @State private var showAddAccount: Bool = false
    
    var body: some View {
        Group {
            if viewModel.account == nil {
                EmptyAccountCard(viewModel: viewModel) { showAddAccount = true }
            } else {
                LinkedAccountCard(account: viewModel.account!)
            }
        }
        .sheet(isPresented: $showAddAccount) {
            NavigationStack {
                AddAccountView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

struct EmptyAccountCard: View {
    @ObservedObject var viewModel: SettingViewModel
    var onAdd: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Circle().fill(Color.white)
                    .frame(width: 46, height: 46)
                    .overlay(Image(systemName: "creditcard.trianglebadge.exclamationmark")
                        .font(.system(size: 20)).foregroundColor(Color("CardColor")))
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("No account connected")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color("CardText"))
                    
                    Text(Constants.accountNotFoundDesc.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            Button(action: onAdd) {
                Text("Add account")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("InsideCarBottomColor"))
                    .frame(maxWidth: .infinity).padding(.vertical, 13)
                    .background(Color("CardColor"), in: RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(16)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

struct LinkedAccountCard: View {
    var account: Account
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Linked account", systemImage: "checkmark.seal.fill")
                    .font(.system(size: 12, weight: .bold)).foregroundColor(.green)
                    .padding(.horizontal, 10).padding(.vertical, 6)
                Spacer()

            }
            VStack(spacing: 10) {
                HStack {
                    Circle().fill(Color.white).frame(width: 30, height: 30)
                        .overlay(Image(systemName: "number").font(.system(size: 12, weight: .semibold)).foregroundColor(Color("CardColor")))
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    Text("Account No.").font(.system(size: 12)).foregroundColor(.gray)
                    Spacer()
                    Text(account.account_no ?? "—").font(.system(size: 12, weight: .semibold))
                }
                Divider().overlay(Color("CardText").opacity(0.12))
                HStack {
                    Circle().fill(Color.white).frame(width: 30, height: 30)
                        .overlay(Image(systemName: "building.columns").font(.system(size: 12, weight: .semibold)).foregroundColor(Color("CardColor")))
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    Text("Bank").font(.system(size: 12)).foregroundColor(.gray)
                    Spacer()
                    Text(account.bankName ?? "—").font(.system(size: 12, weight: .semibold))
                }
                Divider().overlay(Color("CardText").opacity(0.12))
                HStack {
                    Circle().fill(Color.white).frame(width: 30, height: 30)
                        .overlay(Image(systemName: "dollarsign.circle").font(.system(size: 12, weight: .semibold)).foregroundColor(Color("CardColor")))
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    Text("Balance").font(.system(size: 12)).foregroundColor(.gray)
                    Spacer()
                    Text(getBalance()).font(.system(size: 12, weight: .semibold))
                }
            }
            .padding(14)
            .settingInset(0.55, radius: 14)
        }
        .padding(16)
        .background(Color("CardBackground"), in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
    
    func getBalance() -> String {
        let bal = account.balance
        if bal == 0 { return "0.00" }
        return String(format: "%.2f", bal)
    }
}

// Personal details
struct PersonalDetailsCard: View {
    var user: User?
    @State var showEditSheet:Bool = false
    @ObservedObject  var viewModel:SettingViewModel

    var body: some View {
        SettingCardContainer(title: "Personal details", subtitle: "Your profile information", iconName: "person.fill", showEditBtn: true, onClick: {
            showEditSheet = true
        }) {
            VStack(spacing: 0) {
                SimpleRow(icon: "person", title: "Full name", value: user?.name)
                SimpleDivider()
                SimpleRow(icon: "envelope", title: "Email", value: user?.email)
                SimpleDivider()
                SimpleRow(icon: "phone.fill", title: "Phone", value: user?.phone)
                SimpleDivider()
                CountryRow(value: user?.country?.capitalized, user: user)
            }
        }.sheet(isPresented: $showEditSheet){
            NavigationStack {
                PersonalDetailsView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

// Account details
struct AccountDetailsCard: View {
    var user: User?
    var account: Account?
    @ObservedObject  var viewModel:SettingViewModel
    @State var showEditSheet:Bool = false
    var body: some View {
        SettingCardContainer(title: "Account details", subtitle: "Billing & plan information", iconName: "creditcard.fill", showEditBtn: true, onClick: {
            showEditSheet = true
        }) {
            VStack(spacing: 0) {
                SimpleRow(icon: "building.columns.fill", title: "Bank Name", value: account?.bankName)
                SimpleDivider()
                SimpleRow(icon: "envelope.open", title: "Billing email", value: user?.email)
                SimpleDivider()
                HStack(spacing: 12) {
                    Circle().fill(Color.white).frame(width: 30, height: 30)
                        .overlay(Image(systemName: "wallet.bifold").foregroundColor(Color("CardColor")))
                    Text("Bank Account").font(.system(size: 13))
                    Spacer()
                    Text(viewModel.account?.account_no ?? "-").font(.system(size: 13)).foregroundColor(.gray)
                }
                .padding(.horizontal, 10).padding(.vertical, 10)
            }
        }.sheet(isPresented: $showEditSheet){
            NavigationStack {
                AccountDetailsView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

// Preferences
struct PreferencesCard: View {
    var user: User?
    @State private var pushOn = true
    @AppStorage("forceDarkMode") private var forceDarkMode = false
    
    var body: some View {
        SettingCardContainer(title: "Preferences", subtitle: "App experience", iconName: "slider.horizontal.3", showEditBtn: false) {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Circle().fill(Color.white).frame(width: 30, height: 30)
                        .overlay(Image(systemName: "bell.badge.fill").foregroundColor(Color("CardColor")))
                    Text("Push Notifications").font(.system(size: 13))
                    Spacer()
                    Toggle("", isOn: $pushOn).labelsHidden().tint(Color("CardColor"))
                }
                .padding(10)
                SimpleDivider()
                HStack(spacing: 12) {
                    Circle().fill(Color.white).frame(width: 30, height: 30)
                        .overlay(Image(systemName: "moon.fill").foregroundColor(Color("CardColor")))
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Dark Mode").font(.system(size: 13))
                        Text(forceDarkMode ? "On" : "Follows system").font(.system(size: 11)).foregroundColor(.gray)
                    }
                    Spacer()
                    Toggle("", isOn: $forceDarkMode).labelsHidden().tint(Color("CardColor"))
                }
                .padding(10)
                SimpleDivider()
                HStack(spacing: 12) {
                    Circle().fill(Color.white).frame(width: 30, height: 30)
                        .overlay(Image(systemName: "dollarsign.circle.fill").foregroundColor(Color("CardColor")))
                    Text("Default Currency").font(.system(size: 13))
                    Spacer()
                    Text(getCurrency()).font(.system(size: 12)).foregroundColor(.gray)
                    Image(systemName: "chevron.right").foregroundColor(.gray.opacity(0.4))
                }
                .padding(10)
                SimpleDivider()
                HStack(spacing: 12) {
                    Circle().fill(Color.white).frame(width: 30, height: 30)
                        .overlay(Image(systemName: "globe.americas.fill").foregroundColor(Color("CardColor")))
                    Text("Language").font(.system(size: 13))
                    Spacer()
                    Text("English").font(.system(size: 12)).foregroundColor(.gray)
                    Image(systemName: "chevron.right").foregroundColor(.gray.opacity(0.4))
                }
                .padding(10)
            }
        }
    }
    
    func getCurrency() -> String {
        if let raw = user?.country, let c = Country(rawValue: raw) { return c.currencyCode }
        return "USD"
    }
}

struct AppVersionFooter: View {
    var body: some View {
        Text("Venzer Finance v1.0 • Made with care")
            .font(.system(size: 10)).foregroundColor(.gray.opacity(0.7))
            .frame(maxWidth: .infinity).padding(.top, 4)
    }
}

struct SupportAndLogoutView: View {
    var onLogout: () -> Void
    var body: some View { AppVersionFooter() }
}
