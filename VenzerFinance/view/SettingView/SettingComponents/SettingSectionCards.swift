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
    
    var body: some View {
        if viewModel.account == nil {
            EmptyAccountCard()
        } else {
            LinkedAccountCard(account: viewModel.account!)
        }
    }
}

struct EmptyAccountCard: View {
    @State var showEditSheet:Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("CardColor").opacity(0.09))
                    .frame(width: 46, height: 46)
                    .overlay(Image(systemName: "creditcard.trianglebadge.exclamationmark")
                        .font(.system(size: 20)).foregroundColor(Color("CardColor")))
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("No account connected")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(Constants.accountNotFoundDesc.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            Button {
                showEditSheet = true
            } label: {
                Text("Add account")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("InsideCarBottomColor"))
                    .frame(maxWidth: .infinity).padding(.vertical, 13)
                    .background(Color("CardColor"), in: RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
        .sheet(isPresented: $showEditSheet){
            NavigationStack {
                AddAccountView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

struct LinkedAccountCard: View {
    var account: Account
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Linked account", systemImage: "checkmark.seal.fill")
                    .font(.system(size: 12, weight: .bold)).foregroundColor(Color("CardColor"))
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(Color("InsideCarBottomColor").opacity(0.28), in: Capsule())
                Spacer()
                Text("Active").font(.system(size: 10, weight: .bold)).foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4).background(Color.green.opacity(0.85), in: Capsule())
            }
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "number").foregroundColor(Color("CardColor"))
                    Text("Account No.").font(.system(size: 12)).foregroundColor(.gray)
                    Spacer()
                    Text(account.account_no ?? "—").font(.system(size: 12, weight: .semibold))
                }
                Divider().opacity(0.06)
                HStack {
                    Image(systemName: "building.columns").foregroundColor(Color("CardColor"))
                    Text("Bank").font(.system(size: 12)).foregroundColor(.gray)
                    Spacer()
                    Text(account.bankName ?? "—").font(.system(size: 12, weight: .semibold))
                }
                Divider().opacity(0.06)
                HStack {
                    Image(systemName: "dollarsign.circle").foregroundColor(Color("CardColor"))
                    Text("Balance").font(.system(size: 12)).foregroundColor(.gray)
                    Spacer()
                    Text(getBalance()).font(.system(size: 12, weight: .semibold))
                }
            }
            .padding(14)
            .background(Color("InsideCarTopColor").opacity(0.55), in: RoundedRectangle(cornerRadius: 14))
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
    
    func getBalance() -> String {
        guard let bal = account.balance else { return "—" }
        let v = bal.doubleValue
        if v == 0 { return "0.00" }
        return String(format: "%.2f", v)
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
                SimpleRow(icon: "building.columns.fill", title: "Bank Name", value: account == nil ? "—" : "Personal")
                SimpleDivider()
                SimpleRow(icon: "envelope.open", title: "Billing email", value: user?.email)
                SimpleDivider()
                HStack(spacing: 12) {
                    Circle().fill(Color.white).frame(width: 30, height: 30)
                        .overlay(Image(systemName: "wallet.bifold").foregroundColor(Color("CardColor")))
                    Text("Bank Account").font(.system(size: 13))
                    Spacer()
                    Text("8470890...").font(.system(size: 13)).foregroundColor(.gray)
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
