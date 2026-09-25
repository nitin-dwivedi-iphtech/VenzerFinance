//
//  AccountDetailsView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//
import SwiftUI

struct AccountDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel:SettingViewModel
    
    @State private var showAddAccount: Bool = false
    @State private var accountNo: String = ""
    @State private var bankName: String = ""
    @State private var balanceText: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                if viewModel.account != nil {
                    cardPreview
                        .padding(.top, 8)
                    
                    formCard
                    saveButton
                } else {
                    emptyState
                        .padding(.top, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 30)
        }
        .navigationTitle("Account details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold)).foregroundColor(.black)
                        .frame(width: 36, height: 36).background(Color.white, in: Circle())
                        .overlay(Circle().stroke(Color.black.opacity(0.06), lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
                }
            }
        }
        .background { CustomBackgroundView() }
        .onAppear { seedFields() }
        .onChange(of: viewModel.account?.id) { _, _ in seedFields() }
        .alert("Missing details", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Account number, bank name and balance are all required.")
        }
        .sheet(isPresented: $showAddAccount) {
            NavigationStack {
                AddAccountView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    private func seedFields() {
        guard let acc = viewModel.account else { return }
        accountNo = acc.account_no ?? ""
        bankName = acc.bankName ?? ""
        balanceText = String(format: "%.2f", acc.balance)
    }
    
    private var cardPreview: some View {
        AccountCardView(
            displayName: bankName.isEmpty ? "Your Bank" : bankName,
            balanceText: balanceText.isEmpty ? "$0.00" : "$\(balanceText)",
            lastFour: accountNo.isEmpty ? "••••" : String(accountNo.suffix(4))
        )
        .padding(.horizontal, 16)
    }
    
    private var formCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle().fill(Color("CardColor")).frame(width: 28, height: 28)
                    .overlay(Image(systemName: "creditcard.fill").font(.system(size: 12, weight: .semibold)).foregroundColor(Color("InsideCarBottomColor")))
                VStack(alignment: .leading, spacing: 1) {
                    Text("Edit account").font(.system(size: 14, weight: .bold)).foregroundColor(.black)
                    Text("Update number, bank and balance").font(.system(size: 11)).foregroundColor(.gray)
                }
                Spacer()
                Circle().fill(Color("InsideCarTopColor")).frame(width: 28, height: 28)
                    .overlay(Image(systemName: "lock.shield.fill").font(.system(size: 11)).foregroundColor(Color("CardColor")))
            }
            
            VStack(spacing: 10) {
                modernField(title: "Account Number", text: $accountNo, icon: "number", placeholder: "0849 1234 5678", keyboard: .numberPad)
                modernField(title: "Bank Name", text: $bankName, icon: "building.columns.fill", placeholder: "e.g. PayPal")
                modernField(title: "Balance", text: $balanceText, icon: "dollarsign.circle.fill", placeholder: "0.00", keyboard: .decimalPad)
            }
            .padding(12)
            .background(Color("InsideCarTopColor").opacity(0.38), in: RoundedRectangle(cornerRadius: 16))
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 16)
    }
    
    private func modernField(title: String, text: Binding<String>, icon: String, placeholder: String = "", keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color("InsideCarBottomColor")
                        .opacity(0.18)).frame(width: 22, height: 22)
                    .overlay(Image(systemName: icon).font(.system(size: 10, weight: .semibold)).foregroundColor(Color("CardColor")))
                
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.gray)
                    .tracking(0.2)
                
            }
            HStack(spacing: 8) {
                TextField(placeholder, text: text)
                    .font(.system(size: 14, weight: .medium)).foregroundColor(.black)
                    .keyboardType(keyboard)
                
                Image(systemName: "pencil.circle.fill").font(.system(size: 16)).foregroundColor(Color("CardColor").opacity(0.8))
            }
            .padding(.horizontal, 14).padding(.vertical, 12)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.06), lineWidth: 1))
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        }
    }
    
    private var saveButton: some View {
        Button {
            guard Helper.isFormValid(for: [accountNo, bankName, balanceText]) else {
                showAlert = true
                return
            }
            viewModel.accountNo = accountNo
            viewModel.bankName = bankName
            viewModel.balanceText = balanceText
            viewModel.saveAccountDetails()
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Text("Save changes").font(.system(size: 16, weight: .semibold))
                Image(systemName: "arrow.right").font(.system(size: 13, weight: .bold))
            }
            .foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 16)
            .background(Color("CardColor"), in: Capsule())
            .shadow(color: Color("CardColor").opacity(0.25), radius: 10, x: 0, y: 6)
        }
        .padding(.horizontal, 20)
        .padding(.top, 2)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.08), style: StrokeStyle(lineWidth: 1, dash: [6, 6]))
                    .frame(height: 140)
                    .background(Color.white.opacity(0.6), in: RoundedRectangle(cornerRadius: 20))
                
                VStack(spacing: 10) {
                    ZStack {
                        Circle().fill(Color("CardColor").opacity(0.09)).frame(width: 56, height: 56)
                        Image(systemName: "creditcard.trianglebadge.exclamationmark")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color("CardColor"))
                    }
                    Text("No account yet")
                        .font(.system(size: 16, weight: .bold)).foregroundColor(.black)
                    Text("Add your first bank account to track balance and manage payments in one place.")
                        .font(.system(size: 12)).foregroundColor(.gray).multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 8) {
                Button {
                    showAddAccount = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill").font(.system(size: 14, weight: .semibold))
                        Text("Add Account").font(.system(size: 15, weight: .bold))
                    }
                    .foregroundColor(Color("InsideCarBottomColor"))
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Color("CardColor"), in: RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color("CardColor").opacity(0.18), radius: 8, x: 0, y: 4)
                }
                
                Text("You can add a personal, business or shared account")
                    .font(.system(size: 11)).foregroundColor(.gray.opacity(0.9))
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.06), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 16)
    }
}

//#Preview {
//    NavigationStack { AccountDetailsView() }
//}
