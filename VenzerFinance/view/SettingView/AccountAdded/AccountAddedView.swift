//
//  AccountAddedView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 25/09/26.
//

import SwiftUI

struct AccountAddedView: View {
    @ObservedObject var viewModel:SettingViewModel

    var bankName: String
    var accountNo: String
    var balanceText: String
    var onDone: () -> Void
    var onViewDetails: () -> Void
    var onBack: () -> Void

    @State private var showCheck = false
    @State private var showContent = false

    init(
        bankName: String = "PayPal",
        accountNo: String = "0849 1234 5678",
        balanceText: String = "$4,309.00",
        viewModel:SettingViewModel,
        onDone: @escaping () -> Void = {},
        onViewDetails: @escaping () -> Void = {},
        onBack: @escaping () -> Void = {}
    ) {
        self.bankName = bankName
        self.accountNo = accountNo
        self.balanceText = balanceText
        self.onDone = onDone
        self.onViewDetails = onViewDetails
        self.onBack = onBack
        self.viewModel = viewModel
    }

    private var lastFour: String {
        accountNo.isEmpty ? "••••" : String(accountNo.suffix(4))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                successHero
                    .padding(.top, 12)

                titleBlock

                AccountCardView(
                    displayName: bankName.isEmpty ? "Your Bank" : bankName,
                    balanceText: balanceText.isEmpty ? "$0.00" : balanceText,
                    lastFour: lastFour,
                    bankLabel: bankName.isEmpty ? "PayPal" : bankName
                )
                .padding(.horizontal, 16)

                detailsCard

                actionButtons
            }
            .padding(.bottom, 24)
        }
        .navigationTitle("Account Added")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { onBack() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                        .background(Color.white, in: Circle())
                        .overlay(Circle().stroke(Color.black.opacity(0.06), lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                }
            }
        }
        .background { CustomBackgroundView() }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.65)) {
                showCheck = true
            }
            withAnimation(.easeOut(duration: 0.45).delay(0.15)) {
                showContent = true
            }
        }
    }

    // Success hero
    private var successHero: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color("CardColor").opacity(0.10))
                    .frame(width: 120, height: 120)
                    .scaleEffect(showCheck ? 1 : 0.7)
                    .opacity(showCheck ? 1 : 0)

                Circle()
                    .fill(Color("InsideCarBottomColor").opacity(0.28))
                    .frame(width: 96, height: 96)
                    .scaleEffect(showCheck ? 1 : 0.6)
                    .opacity(showCheck ? 1 : 0)

                Circle()
                    .fill(Color("CardColor"))
                    .frame(width: 68, height: 68)
                    .shadow(color: Color("CardColor").opacity(0.32), radius: 14, x: 0, y: 8)
                    .scaleEffect(showCheck ? 1 : 0.4)
                    .opacity(showCheck ? 1 : 0)

                Image(systemName: "checkmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("InsideCarBottomColor"))
                    .scaleEffect(showCheck ? 1 : 0.4)
                    .opacity(showCheck ? 1 : 0)
            }
            .animation(.spring(response: 0.55, dampingFraction: 0.62), value: showCheck)
        }
        .frame(maxWidth: .infinity)
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 10)
    }

    private var titleBlock: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Circle().fill(Color.green).frame(width: 6, height: 6)
                Text("ACCOUNT LINKED")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray)
                    .tracking(0.8)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white, in: Capsule())
            .overlay(Capsule().stroke(Color.black.opacity(0.06), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)

            Text("Account Added!")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)

            Text("Your \(bankName.isEmpty ? "bank" : bankName) account ending in \(lastFour) is now connected and ready to use.")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .padding(.horizontal, 32)
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 10)
    }

    // Details card
    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle().fill(Color("CardColor")).frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("InsideCarBottomColor"))
                    )
                VStack(alignment: .leading, spacing: 1) {
                    Text("Linked account")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                    Text("Active • Ready for payments")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("Active")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.green.opacity(0.9), in: Capsule())
            }

            VStack(spacing: 0) {
                detailRow(icon: "building.columns.fill", title: "Bank", value: bankName.isEmpty ? "—" : bankName)
                SimpleDivider()
                detailRow(icon: "number", title: "Account No.", value: accountNo.isEmpty ? "—" : accountNo)
                SimpleDivider()
                detailRow(icon: "dollarsign.circle.fill", title: "Balance", value: balanceText.isEmpty ? "$0.00" : balanceText)
            }
            .padding(6)
            .background(Color("InsideCarTopColor").opacity(0.55), in: RoundedRectangle(cornerRadius: 16))
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 16)
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 12)
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.white)
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color("CardColor"))
                )
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)

            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.black.opacity(0.8))

            Spacer()

            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.black.opacity(0.85))
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
    }

    // Buttons
    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button {
                onViewDetails()
            } label: {
                HStack(spacing: 8) {
                    Text("View Account Details")
                        .font(.system(size: 16, weight: .semibold))
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color("CardColor"), in: Capsule())
                .shadow(color: Color("CardColor").opacity(0.25), radius: 10, x: 0, y: 6)
            }
            .buttonStyle(.plain)

            Button {
                onDone()
            } label: {
                Text("Done")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color("CardColor"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white, in: Capsule())
                    .overlay(Capsule().stroke(Color("CardColor").opacity(0.18), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 2)
        .opacity(showContent ? 1 : 0)
    }

}

#Preview {
    AccountAddedView(viewModel:SettingViewModel())
}
    
