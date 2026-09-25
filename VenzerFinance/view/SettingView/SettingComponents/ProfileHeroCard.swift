//
//  ProfileHeroCard.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//

import SwiftUI

//  hero card
struct ProfileHeroCard: View {
    @ObservedObject var viewModel: SettingViewModel
    @State private var showEditSheet: Bool = false

    var body: some View {
        VStack(spacing: 14) {
            topHeader
            bottomStats
            bottomButtons
        }
        .padding(18)
        .background(Color("CardColor"))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.11), radius: 18, x: 0, y: 8)
    }

    // top small header
    private var topHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Text("venzer. member")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.black.opacity(0.7))
                Spacer()
                HStack(spacing: 5) {
                    Circle().fill(Color.green).frame(width: 7, height: 7)
                    Text("Verified").font(.system(size: 11, weight: .bold)).foregroundColor(Color("CardColor"))
                }
                .padding(.horizontal, 10).padding(.vertical, 5)
                .background(Color.white, in: Capsule())
            }
            .padding().background(Color("InsideCarTopColor"))

            HStack(spacing: 12) {
                Image("image")
                    .resizable().scaledToFill().frame(width: 56, height: 56).clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.user?.name ?? "—").font(.system(size: 16, weight: .bold)).foregroundColor(.black).lineLimit(1)
                    Text(viewModel.user?.email ?? "—").font(.system(size: 12)).foregroundColor(.black.opacity(0.6)).lineLimit(1)

                    if let raw = viewModel.user?.country, let c = Country(rawValue: raw) {
                        HStack(spacing: 6) {
                            Image(c.flagImageName).resizable().frame(width: 18, height: 18).clipShape(Circle())
                            Text("\(c.rawValue.capitalized) • \(c.currencyCode)").font(.system(size: 10, weight: .bold))
                        }
                        .padding(.horizontal, 9).padding(.vertical, 5)
                        .background(Color.white, in: Capsule())
                    } else {
                        Text("Country not set").font(.system(size: 11)).foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .padding().background(Color("InsideCarBottomColor"))
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // 3 small boxes for balance / account / bank
    private var bottomStats: some View {
        HStack(spacing: 10) {
            statBox(icon: "wallet.pass.fill", title: "Balance", value: getBalance())
            statBox(icon: "number.circle.fill", title: "Account", value: getShortNo())
            statBox(icon: "building.columns.fill", title: "Bank", value: viewModel.account?.bankName ?? "—")
        }
    }

    private func statBox(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 11, weight: .semibold)).foregroundColor(Color("InsideCarBottomColor"))
            Text(title).font(.system(size: 10, weight: .semibold)).foregroundColor(.white.opacity(0.7))
            Text(value).font(.system(size: 12, weight: .bold)).foregroundColor(.white).lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 16))
    }

    private var bottomButtons: some View {
        HStack(spacing: 10) {
            Button {
                showEditSheet = true
            } label: {
                Label("Edit Profile", systemImage: "person.crop.circle.badge.checkmark")
                    .font(.system(size: 13, weight: .semibold)).frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Color.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 14))
            }.tint(.white)

            ShareLink(item: shareText) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Color.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 14))
            }
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                PersonalDetailsView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private var shareText: String {
        let name = viewModel.user?.name ?? "Venzer user"
        var text = "\(name) on Venzer Finance"
        if let email = viewModel.user?.email, !email.isEmpty {
            text += " • \(email)"
        }
        return text
    }

    private func getBalance() -> String {
        guard let bal = viewModel.account?.balance else { return "—" }
        if bal == 0 { return "0.00" }
        return String(format: "%.2f", bal)
    }

    private func getShortNo() -> String {
        guard let no = viewModel.account?.account_no, !no.isEmpty else { return "—" }
        if no.count > 12 { return "•••• \(no.suffix(4))" }
        return no
    }
}
